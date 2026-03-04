import os
import shutil

def add_to_startup(file_path, shortcut_name):
    appdata_path = os.environ['AppData']
    startup_path = os.path.join(appdata_path, 'Microsoft','Windows','Start Menu','Programs','Startup')
    shortcut_path = os.path.join(startup_path,f'{shortcut_name}.lnk')

    vbs = f"""
    Set oWS = WScript.CreateObject("WScript.Shell")
    sLinkFile = "{shortcut_path}"
    Set oLink = oWS.CreateShortcut(sLinkFile)
    oLink.TargetPath = "{file_path}"
    oLink.Save
    """
    vbs_path = os.path.join(os.getcwd(),'create_shortcut.vbs')
    with open(vbs_path,"w") as f:
        f.write(vbs)
    
    os.system(f'wscript.exe "{vbs_path}"')

    os.remove(vbs_path)
file_path = os.path.join(os.getcwd(), 'papaev_vpo_lab.vbs')
shortcut_name = "PapaevVPOExample"
with open('papaev_vpo_lab.vbs','w') as f:
    f.write(f"""MsgBox "Персистентность Папка запуска", vbOKOnly + vbInformation,"ЛР 7.2.3 Папаев БН" """)
add_to_startup(file_path,shortcut_name)

print("Все сработало")
