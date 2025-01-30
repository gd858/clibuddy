### **📖 CliBuddy – AI-Powered Terminal Assistant** 🚀  

**CliBuddy** transforms **natural language instructions** into **precise Linux commands** using OpenAI’s API. Whether you're a beginner or a power user, it simplifies terminal commands with AI assistance.  

---

## **📌 Installation Guide**  

### **1️⃣ Clone the Repository**
```bash
git clone https://github.com/gd858/clibuddy.git
```

### **2️⃣ Navigate to the Project Directory**
```bash
cd clibuddy
```

### **3️⃣ Make the Installer Executable**
```bash
chmod +x installer.sh
```

### **4️⃣ Run the Installer**
```bash
./installer.sh
```

✅ This will:  
- Install **CliBuddy** to `/usr/local/bin/clibuddy`  
- Set up API key storage at `~/.config/clibuddy/api_key`  
- Move required files (`robot.txt`) to `/usr/share/clibuddy/`  

---

## **📌 Usage**
### **Run CliBuddy with a Command**
```bash
clibuddy "List all files in the current directory"
```

### **Interactive Mode (Prompt Before Running)**
```bash
clibuddy -i "Show disk usage for home directory"
```

### **Get Help**
```bash
clibuddy -h
```

---

## **📌 Uninstallation**
To completely remove CliBuddy from your system:
```bash
sudo ./uninstaller.sh
```

---

## **📌 Features**
✅ **AI-powered Linux command generation**  
✅ **Secure API key storage (`~/.config/clibuddy/api_key`)**  
✅ **Interactive execution with `-i` flag**  
✅ **Supports multiple OpenAI models (`-m <model>`)**  
✅ **Easy installation & cleanup (`setup.sh`, `uninstaller.sh`)**  

---

**🚀 Transform your terminal experience with AI!**
