# risc-v-kernelci
**Kernel Version : 6.13.0-rc2**

**System: NixOS & Ubuntu**
### Tests:
- [x] Kunittests 
- [x] Kselftests
- [ ] Kmemleak
- [ ] KASAN
- [ ] Code Coverage Tools (gcov, KCOV)
- [ ] Dynamic Analysis Tools
- [x] Sparse
- [ ] Smatch
- [x] Coccinelle

<details>
  <summary> custom-kernel boot in nixos? </summary>

## For NixOS (my current system)
I updated the linux_latest kernel pacakge with `src= <linux-6.13.0-rc2 dir>` and custom mod Version inside of a flake file.
```nix
customKernel = pkgs.linuxPackagesFor (pkgs.linux_latest.override {
      argsOverride = rec {
        src = ./linux-6.13.0-rc2; #local source 
        version = "6.13.0";
        modDirVersion = "6.13.0";
      };
    });
in
{
    packages.x86_64-linux = rec {
      kernel = customKernel.kernel;  # Access the kernel derivation specifically
      default = kernel;             # Set the kernel as the default package
    };
}
```
Then imported my package to my system configuration 
```nix
boot.kernelPackages = inputs.customkernel.packages.${pkgs.system}.default;
```

</details>

<details>
  <summary> screenshot: Kernel: arch/x86/boot/bzImage is ready. </summary>

```bash
make defconfig
make -j6 
```
Build Logs: 

![image](https://github.com/user-attachments/assets/b3bff0c8-7919-4a2c-9015-13b1406f04ab)

</details>

<details>
  <summary> screenshot: uname -r </summary>

```bash
  neofetch
  uname -r 
```
  
![neofetch](https://github.com/user-attachments/assets/dbc2bfb4-4aa4-41f1-b925-1368ba30001b)
![uname-r](https://github.com/user-attachments/assets/422302ea-869e-4b59-8cee-ab4a2e5ed22c)
</details>


<details>
  <summary> screenshot: selftests run </summary>
  
![swappy-20250206-034357](https://github.com/user-attachments/assets/ec1f7cf1-70c1-487e-93dc-db34257c9a83)

</details>

<details>
<summary>  Kernel Build and Testing Results Observations </summary>

### **Build Log (`build.log`)**
- **Errors:** 9  
- **Findings:**  
  - Compilation errors related to unresolved symbols in architecture-specific headers.  
  - Fatal errors in inline assembly due to missing dependencies.  
  - No warnings, indicating proper flag handling.  

---

### **Self-Test Logs (`selftest.log`, `selftests-2.log`)**
- **Errors:** 13 (`selftest.log`), 7 (`selftests-2.log`)  
- **Findings Before Fixing Dependencies:**  
  - `syscalls`, `ioctl`, and `breakpoints` tests failed due to missing system calls.  
  - `make[1]: Nothing to be done for 'all'` suggests missing test binaries.  
  - `arm64` and `alsa` self-tests reported failures.  

- **Findings After Fixing Dependencies:**  
  - Resolved missing system calls, reducing failure count.  
  - `arm64` and `breakpoints` tests still failing, likely needing kernel config changes.  

---

### **KUnit Test Log (`kunit-test.log`)**
- **Errors:** 0  
- **Findings:**  
  - **Warnings:** Missing function prototypes in `iomap.c` (`-Wmissing-prototypes`).  
  - **Failures:** 3 test cases failed in low-level I/O operations.  

---

### **Conclusion**
- **Build log shows unresolved symbols in headers.**  
- **Self-tests had missing system calls and binaries.** After fixing, some tests still failed due to kernel config issues.  
- **KUnit tests ran with minor warnings but no critical errors.**  

Further debugging is needed for `arm64` and `breakpoints` failures.

</details>
  




