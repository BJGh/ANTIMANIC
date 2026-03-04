#include <iostream>
#include <windows.h>
#include <TlHelp32.h>
#include <tchar.h>

// Функция для получения ID потока по имени процесса
DWORD GetThreadIdFromProcessName(const char* processName) {
    DWORD processId = 0;
    HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (snapshot != INVALID_HANDLE_VALUE) {
        PROCESSENTRY32 processEntry;
        processEntry.dwSize = sizeof(PROCESSENTRY32);
        if (Process32First(snapshot, &processEntry)) {
            do {
                char szExeFileNarrow[MAX_PATH];
                WideCharToMultiByte(CP_ACP, 0, processEntry.szExeFile, -1, szExeFileNarrow, MAX_PATH, NULL, NULL);
                if (strcmp(szExeFileNarrow, processName) == 0) {
                    processId = processEntry.th32ProcessID;
                    break;
                }
            } while (Process32Next(snapshot, &processEntry));
        }
        CloseHandle(snapshot);
    }

    if (processId == 0) {
        std::cerr << "Не удалось найти процесс: " << processName << std::endl;
        return 0;
    }

    DWORD threadId = 0;
    snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
    if (snapshot != INVALID_HANDLE_VALUE) {
        THREADENTRY32 threadEntry;
        threadEntry.dwSize = sizeof(THREADENTRY32);
        if (Thread32First(snapshot, &threadEntry)) {
            do {
                if (threadEntry.th32OwnerProcessID == processId) {
                    threadId = threadEntry.th32ThreadID;
                    break;
                }
            } while (Thread32Next(snapshot, &threadEntry));
        }
        CloseHandle(snapshot);
    }

    if (threadId == 0) {
        std::cerr << "Не удалось найти поток для процесса: " << processName << std::endl;
    }

    return threadId;
}
int main() {
    //setlocale(LC_ALL, "RUSSIAN");
    const char* dllPath = "C:\\dllacp\\*.dll"; // Укажите путь к вашей DLL
    const char* targetProcessName = "falseapp.exe"; // Изменено на Блокнот

    // 1. Получаем ID потока целевого процесса
    DWORD threadId = GetThreadIdFromProcessName(targetProcessName);
    if (threadId == 0) {
        return 1;
    }

    // 2. Открываем дескриптор потока
    HANDLE hThread = OpenThread(THREAD_SET_CONTEXT | THREAD_GET_CONTEXT | THREAD_SUSPEND_RESUME, FALSE, threadId);
    if (hThread == NULL) {
        std::cerr << "Не удалось открыть дескриптор потока. Ошибка: " << GetLastError() << std::endl;
        return 1;
    }

    //3. Получаем дескриптор процесса (для выделения памяти)
    HANDLE hProcess = OpenProcess(PROCESS_CREATE_THREAD | PROCESS_VM_WRITE | PROCESS_VM_OPERATION | PROCESS_SET_CONTEXT, FALSE, GetProcessIdOfThread(hThread));
    if (hProcess == NULL) {
       // std::cerr << "Не удалось открыть дескриптор процесса. Ошибка: " << GetLastError() << std::endl;
        //CloseHandle(hThread);
        //return 1;
    //}

    // 4. Получаем дескриптор целевого процесса 
    HWND hwndNotepad = FindWindow(NULL, _TEXT("falseapp")); // Поиск окна 
    DWORD dwPID = 0;
    GetWindowThreadProcessId(hwndNotepad, &dwPID);
    HANDLE hProcess = OpenProcess(PROCESS_CREATE_THREAD | PROCESS_VM_WRITE | PROCESS_VM_OPERATION | THREAD_SET_CONTEXT | PROCESS_ALL_ACCESS, FALSE, dwPID);
    if (hProcess) {
        std::cout << "Процесс найден" << std::endl;
    }
    else {
        std::cout << "Ошибка: " << GetLastError() << std::endl;
    }

    Sleep(3000);

    // 5. Выделяем память в целевом процессе для пути к DLL
 LPVOID dllPathRemote = VirtualAllocEx(hProcess, NULL, strlen(dllPath) + 1, MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE);
    if (dllPathRemote == NULL) {
        std::cerr << "Не удалось выделить память в целевом процессе. Ошибка: " << GetLastError() << std::endl;
        CloseHandle(hThread);
        CloseHandle(hProcess);
        return 1;
    }

    // 6. Записываем путь к DLL в выделенную память
    if (!WriteProcessMemory(hProcess, dllPathRemote, dllPath, strlen(dllPath) + 1, NULL)) {
        std::cerr << "Не удалось записать путь к DLL в целевой процесс. Ошибка: " << GetLastError() << std::endl;
        VirtualFreeEx(hProcess, dllPathRemote, 0, MEM_RELEASE);
        CloseHandle(hThread);
        CloseHandle(hProcess);
        return 1;
    }

    // 7. Получаем адрес функции LoadLibraryW
    LPVOID loadLibraryAddress = (LPVOID)GetProcAddress(GetModuleHandleA("kernel32.dll"), "LoadLibraryW");
    if (loadLibraryAddress == NULL) {
        std::cerr << "Не удалось получить адрес LoadLibraryW. Ошибка: " << GetLastError() << std::endl;
        VirtualFreeEx(hProcess, dllPathRemote, 0, MEM_RELEASE);
        CloseHandle(hThread);
        CloseHandle(hProcess);
        return 1;
    }

    // 8. Запускаем APC для загрузки DLL
    if (QueueUserAPC((PAPCFUNC)loadLibraryAddress, hThread, (ULONG_PTR)dllPathRemote) == 0) {
        std::cerr << "Не удалось поставить APC в очередь. Ошибка: " << GetLastError() << std::endl;
        VirtualFreeEx(hProcess, dllPathRemote, 0, MEM_RELEASE);
        CloseHandle(hThread);
        CloseHandle(hProcess);
        return 1;
    }

    std::cout << "APC поставлен в очередь для потока " << threadId << std::endl;

    // 9. Принудительно переводим поток в состояние ожидания (для демонстрации)
    //SuspendThread(hThread);
    //ResumeThread(hThread);
    // Очистка
    VirtualFreeEx(hProcess, dllPathRemote, 0, MEM_RELEASE);
    CloseHandle(hThread);
    CloseHandle(hProcess);

    return 0;
}
