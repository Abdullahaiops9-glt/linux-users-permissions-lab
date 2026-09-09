# Quick Command Reference — Exact Video Order

## All Commands in Order

```bash
# Check current user
id

# Create users
sudo useradd -m ali
sudo useradd -m ahmad

# Set passwords
sudo passwd ali
sudo passwd ahmad

# Verify users
id ali
id ahmad
whoami

# Create group
sudo groupadd high_tech
getent group high_tech

# Add users to group
sudo usermod -aG high_tech ali
sudo usermod -aG high_tech ahmad

# Create shared directory
sudo mkdir /shared
ls -ld /shared

# Set group ownership
sudo chown root:high_tech /shared
ls -ld /shared

# Set permissions with setgid
sudo chmod 2770 /shared
ls -ld /shared

# Test as ali
su - ali
whoami
echo $SHELL
cd /shared
pwd
echo "hello from ali" > ali.txt
cat ali.txt
ls

# Test as ahmad
su - ahmad
whoami
echo $SHELL
cd /shared
pwd
cat ali.txt
echo "hello from ahmad" > ahmad.txt
cat ahmad.txt
ls

# Back to ali — check ahmad file
su - ali
whoami
cd /shared
cat ali.txt
cat ahmad.txt
ls
ls -ltrh

# Create david with no group
sudo useradd -m david
sudo passwd david
su - david
whoami
cd /shared        # Permission Denied — expected
exit

# Final comparison
id ahmad
id ali
id david
```

## Permission Reference

| Value                 | Meaning |

| 2770                  | SetGID + owner full + group full + others none |

| drwxrws---            | SetGID active confirmed |

| s in group position   | SetGID bit set |

## Key Commands Reference

| Command              | Purpose |

| useradd -m           | Create user with home directory |

| passwd               | Set user password |

| groupadd             | Create new group |

| getent group         | Verify group in system database |

| usermod -aG          | Add user to group |

| chown root:group     | Set group ownership |

| chmod 2770           | Set permissions with setgid |

| su - user            | Switch user with full environment |

| id                   | Show user and group info |

| ls -ld               | Show directory permissions |

| ls -ltrh             | List files with details |
