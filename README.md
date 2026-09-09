# Linux Users & Permissions — Permission Denied

**JaanTech YouTube Channel — Practical Lab Companion**

> Follow this repository step by step and you will reproduce exactly what was demonstrated in the video.

---

## What Problem Are We Solving?

In a real Linux environment, multiple users need to work on shared files inside a shared directory. Without correct group membership, ownership, and permission configuration, users either get locked out or have access to things they should not touch. This project shows exactly how to set it up correctly and proves the permission boundary works by testing with a user who has no group membership.

---

## What We Build

- Two users — ali and ahmad — who can both read and write inside a shared directory
- One group — high_tech — that controls access to the shared directory
- One shared directory — /shared — owned by the group with setgid active
- Proof that files created by ali are visible to ahmad and vice versa
- One user — david — who is NOT in the group and gets Permission Denied

---

## Prerequisites

- Ubuntu, Debian, RHEL, or CentOS Linux system
- Terminal with sudo access
- No extra packages needed

---

## Complete Workflow — Exactly as Shown in the Video

---

### STEP 1 — Check Current User Identity

```bash
id
```

Shows who you currently are — your uid, gid, and all groups you belong to. Run this first so you know your starting point.

---

### STEP 2 — Create Two Users

```bash
sudo useradd -m ali
sudo useradd -m ahmad
```

Creates two users — ali and ahmad. The -m flag creates a home directory for each user automatically at /home/ali and /home/ahmad.

---

### STEP 3 — Set Passwords for Both Users

```bash
sudo passwd ali
sudo passwd ahmad
```

Sets a login password for ali and ahmad. You will be prompted to enter and confirm the password for each. This is required to switch to these users later.

---

### STEP 4 — Verify Both Users Were Created

```bash
id ali
id ahmad
```

Shows uid, gid, and group memberships for each user. At this point both users only belong to their own default group. They are not in high_tech yet.

---

### STEP 5 — Check Who You Are

```bash
whoami
```

Confirms your current active user before proceeding.

---

### STEP 6 — Create the Group

```bash
sudo groupadd high_tech
```

Creates a new group named high_tech on the system.

---

### STEP 7 — Verify the Group Was Created

```bash
getent group high_tech
```

Shows the group entry from the system database. Output will look like:

```
high_tech:x:1003:
```

The empty field at the end confirms the group exists but has no members yet.

---

### STEP 8 — Add Both Users to the Group

```bash
sudo usermod -aG high_tech ali
sudo usermod -aG high_tech ahmad
```

Adds ali and ahmad to the high_tech group. The -a flag appends to existing groups. The -G flag specifies the group to add them to.

---

### STEP 9 — Create the Shared Directory

```bash
sudo mkdir /shared
ls -ld /shared
```

Creates the /shared directory. The ls -ld command shows the current ownership and permissions immediately after creation so you can see the default state before we change anything.

---

### STEP 10 — Set Group Ownership

```bash
sudo chown root:high_tech /shared
ls -ld /shared
```

Changes the group owner of /shared to high_tech. Root remains the user owner. The ls -ld after confirms the ownership change happened.

---

### STEP 11 — Set Permissions with SetGID

```bash
sudo chmod 2770 /shared
ls -ld /shared
```

Sets permissions on /shared:

- **2** — SetGID bit. Any file created inside /shared automatically inherits the high_tech group instead of the creator's primary group. This is what allows ali and ahmad to see each other's files.
- **7** — Owner (root) gets full read, write, execute
- **7** — Group (high_tech) gets full read, write, execute
- **0** — Everyone else gets nothing

The ls -ld after confirms the permissions show drwxrws--- with the s in the group execute position confirming setgid is active.

---

### STEP 12 — Test Access as ali

```bash
su - ali
```

Switch to user ali.

```bash
whoami
```
Confirms you are now ali.

```bash
echo $SHELL
```
Shows the shell ali is using.

```bash
cd /shared
```
Navigates into the shared directory. No error means ali has access.

```bash
pwd
```
Confirms you are inside /shared.

```bash
echo "hello from ali" > ali.txt
```
Creates a file ali.txt with content written by ali.

```bash
cat ali.txt
```
Reads and displays the content of ali.txt.

```bash
ls
```
Lists all files in /shared. You will see ali.txt.

---

### STEP 13 — Test Access as ahmad and Verify Cross-User File Visibility

```bash
su - ahmad
```

Switch to user ahmad.

```bash
whoami
```
Confirms you are now ahmad.

```bash
echo $SHELL
```
Shows the shell ahmad is using.

```bash
cd /shared
```
Navigates into /shared. No error means ahmad has access.

```bash
pwd
```
Confirms you are inside /shared.

```bash
cat ali.txt
```
Reads the file created by ali. This works because both users are in high_tech and setgid makes files inherit the group. This is the key moment of the demonstration.

```bash
echo "hello from ahmad" > ahmad.txt
```
Creates ahmad.txt with content written by ahmad.

```bash
cat ahmad.txt
```
Reads and displays the content of ahmad.txt.

```bash
ls
```
Lists all files. You will see both ali.txt and ahmad.txt.

---

### STEP 14 — Switch Back to ali and Verify ahmad's File is Visible

```bash
su - ali
```

Switch back to ali.

```bash
whoami
```
Confirms you are ali.

```bash
cd /shared
```
Navigate into /shared.

```bash
cat ali.txt
```
Reads ali's own file.

```bash
cat ahmad.txt
```
Reads the file created by ahmad. Both users can see each other's files because of the group and setgid configuration.

```bash
ls
```
Lists all files.

```bash
ls -ltrh
```
Lists files with detailed information — permissions, owner, group, size, and timestamp. Shows that both files are owned by their respective creators but the group on both files is high_tech.

---

### STEP 15 — Create a User With No Group Membership and Prove the Boundary

```bash
sudo useradd -m david
sudo passwd david
```

Creates user david with no membership in high_tech.

```bash
su - david
```

Switch to david.

```bash
whoami
```
Confirms you are david.

```bash
cd /shared
```

**Expected output:**
```
-bash: cd: /shared: Permission Denied
```

david cannot enter /shared because he is not a member of high_tech. This proves the permission boundary works exactly as intended.

```bash
exit
```

Exit back.

---

### STEP 16 — Final Comparison of All Three Users

```bash
id ahmad
id ali
id david
```

This is the final proof. The output clearly shows:

- ali — groups include high_tech
- ahmad — groups include high_tech
- david — only in his own default group, not in high_tech

This is why ali and ahmad can access /shared and david cannot.

---

## What the Final Output Shows

```
# id ali
uid=1001(ali) gid=1001(ali) groups=1001(ali),1003(high_tech)

# id ahmad
uid=1002(ahmad) gid=1002(ahmad) groups=1002(ahmad),1003(high_tech)

# id david
uid=1004(david) gid=1004(david) groups=1004(david)

# ls -ltrh /shared
-rw-rw-r-- 1 ali   high_tech 15 Aug  1 10:10 ali.txt
-rw-rw-r-- 1 ahmad high_tech 18 Aug  1 10:15 ahmad.txt
```

---

## Key Concepts

# | Concept                   | Explanation |

| useradd -m                | Creates user with home directory |

| groupadd                  | Creates a new group |

| usermod -aG               | Adds user to group without removing existing groups |

| chown root:high_tech      | Sets group ownership of directory |

| chmod 2770                | SetGID plus full owner and group access, zero for others |

| SetGID bit                | Files created inside inherit the directory group automatically |

| su - username             | Switch user and load full environment |

| getent group              | Verify group exists in system database |

---

## Watch the Full Video on YouTube for practical Linux, Docker, and DevOps walkthroughs.
YouTube: **JaanTech** — Linux Users & Permissions — Permission Denied

---

## Author 
JaanTech

Follow JaanTech on YouTube for practical Linux, Docker, and DevOps walkthroughs.
