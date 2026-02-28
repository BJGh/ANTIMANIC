import subprocess
import os
import tkinter as tk
from tkinter import scrolledtext, messagebox, filedialog
import threading
import psutil

def run_long_test(disk="/dev/disk0", progress_var=None):
    """Runs a long self-test on the specified disk."""
    try:
        # Start the self-test and capture output
        process = subprocess.Popen(["smartctl", "-t", "long", disk], stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                   text=True)
        for line in process.stdout:
            # Look for the line containing the test progress
            if "Percent" in line:
                percent = line.split()[5]  # Extract the percentage from the line
                # Update the progress variable with the test progress
                if progress_var:
                    progress_var.set(f"Self-test in progress: {percent}")
        process.communicate()  # Wait for the process to finish
    except FileNotFoundError:
        print("Error: smartctl not found. Please install it.")

def run_short_test(disk="/dev/disk0", progress_var=None):
    """Runs a short self-test on the specified disk."""
    try:
        # Start the short self-test and capture output
        process = subprocess.Popen(["smartctl", "-t", "short", disk], stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                   text=True)
        for line in process.stdout:
            # Look for the line containing the test progress
            if "Percent" in line:
                percent = line.split()[5]  # Extract the percentage from the line
                # Update the progress variable with the test progress
                if progress_var:
                    progress_var.set(f"Short test in progress: {percent}")
        process.communicate()  # Wait for the process to finish
    except FileNotFoundError:
        print("Error: smartctl not found. Please install it.")

def cancel_self_test():
    """Cancels the ongoing self-test."""
    try:
        subprocess.run(["smartctl", "-X", "/dev/disk0"])
    except FileNotFoundError:
        print("Error: smartctl not found. Please install it.")

def get_smart_data(disk="/dev/disk0"):
    """Retrieves SMART data using smartctl."""
    try:
        result = subprocess.run(["smartctl", "-a", disk], capture_output=True, text=True)
        return result.stdout
    except FileNotFoundError:
        messagebox.showerror("Error", "smartctl not found. Please install it.")

def save_smart_data():
    """Saves SMART data to a text file."""
    smart_data = get_smart_data(disk_combobox.get())
    file_path = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Text files", "*.txt")])
    if file_path:
        with open(file_path, "w") as file:
            file.write(smart_data)

def read_sector(disk, sector_no=0):
    """Read a single sector of the specified disk."""
    read = None
    with open(disk, 'rb') as fp:
        fp.seek(sector_no * 512)
        read = fp.read(512)
    return read

def display_sector_data():
    """Displays sector data in the Tkinter text area."""
    selected_disk = disk_combobox.get()
    if os.name == "nt":
        sector_data = read_sector(r"\\.\physicaldrive0")
    else:
        sector_data = read_sector(selected_disk)
    text_area.delete("1.0", tk.END)
    text_area.insert(tk.END, str(sector_data))

def update_sector_data(*args):
    """Updates sector data when the selected disk changes."""
    # We don't do anything here, as sector viewing should only be triggered by explicit request

def start_self_test():
    """Starts a self-test on the specified disk."""
    selected_disk = disk_combobox.get()
    threading.Thread(target=run_long_test, args=(selected_disk,)).start()

def start_short_test():
    """Starts a short self-test on the specified disk."""
    selected_disk = disk_combobox.get()
    threading.Thread(target=run_short_test, args=(selected_disk,)).start()

def start_smart_analysis():
    """Starts SMART analysis on the specified disk."""
    selected_disk = disk_combobox.get()
    smart_data = get_smart_data(selected_disk)
    text_area.delete("1.0", tk.END)
    text_area.insert(tk.END, smart_data)

# Create main window
window = tk.Tk()
window.title("Hard Drive SMART Data")

# Create Combobox for disk selection
all_disks = [disk.device for disk in psutil.disk_partitions(all=True)]
disk_combobox = tk.StringVar(window)
disk_combobox.set(all_disks[0])  # Set default disk
disk_combobox_menu = tk.OptionMenu(window, disk_combobox, *all_disks)
disk_combobox_menu.pack(pady=5)

# Create button to start SMART analysis
start_smart_analysis_button = tk.Button(window, text="Start SMART Analysis", command=start_smart_analysis)
start_smart_analysis_button.pack(pady=5)

# Create button to start self-test
start_test_button = tk.Button(window, text="Start Self-Test", command=start_self_test)
start_test_button.pack(pady=5)

# Create button to start short self-test
start_short_test_button = tk.Button(window, text="Start Short Test", command=start_short_test)
start_short_test_button.pack(pady=5)

# Create button to cancel self-test
cancel_self_test_button = tk.Button(window, text="Cancel Self-Test", command=cancel_self_test)
cancel_self_test_button.pack(pady=5)

# Create button to fetch sector data
fetch_sector_button = tk.Button(window, text="Fetch Sector Data", command=display_sector_data)
fetch_sector_button.pack(pady=5)

# Create button to save SMART data
save_smart_data_button = tk.Button(window, text="Save Results", command=save_smart_data)
save_smart_data_button.pack(pady=5)

# Create text area for output
text_area = scrolledtext.ScrolledText(window, wrap=tk.WORD, width=105, height=25)
text_area.pack(padx=10, pady=10)

window.mainloop()