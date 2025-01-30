### **📖 CliBuddy – AI-Powered Terminal Assistant** 🚀  

**CliBuddy** transforms **natural language instructions** into **precise Linux commands** using OpenAI’s API. Whether you're a beginner or a power user, it simplifies terminal commands with AI assistance.  

---

## **📌 Installation Guide**  

You can install **CliBuddy** using **Git** or by downloading the `.tar.gz` archive.

### **Option 1: Install via Git**
```bash
git clone https://github.com/gd858/clibuddy.git
cd clibuddy
chmod +x installer.sh
./installer.sh
```

### **Option 2: Install via Tarball**
```bash
curl -L -o clibuddy.tar.gz "https://github.com/gd858/clibuddy/archive/refs/tags/v1.0.0.tar.gz"
tar -xzvf clibuddy.tar.gz
cd clibuddy-1.0.0
chmod +x installer.sh
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
