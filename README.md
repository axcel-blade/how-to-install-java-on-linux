# How to install java on linux
A complete guide for installing Java Development Kit (JDK) on Linux systems, featuring step-by-step instructions for multiple distributions, environment variable configuration, version management, and troubleshooting tips to help you set up a reliable Java development environment.

## Installation of SDKMAN
Installing SDKMAN! on UNIX is a breeze. It effortlessly sets up on macOS, Linux and Windows (with WSL). Plus, it's compatible with both Bash and ZSH shells.

Just launch a new terminal and type in:

```
curl -s "https://get.sdkman.io" | bash
```

Follow the on-screen instructions to wrap up the installation. Afterward, open a new terminal or run the following in the same shell:

```
source "$HOME/.sdkman/bin/sdkman-init.sh"
```

Lastly, run the following snippet to confirm the installation's success:

```
sdk version
```

You should see output containing the latest script and native versions:

```
SDKMAN!
script: 5.19.0
native: 0.5.0
```

## Installation of java
To see all avaiable versions for your platform

```
sdk list java
```
Replace the x.y.z-dist with identifier from the above command execution

### JDK Distributions
#### Java SE Development Kit(Oracle)
This proprietary Java Development Kit is an implementation of the Java Platform, Standard Edition released by Oracle Corporation in the form of a binary product aimed at Java developers on Linux, macOS or Windows. The JDK includes a private JVM and a few other resources to finish the development of a Java application. It is distributed under the Oracle No-Fee Terms and Conditions License

```
sdk install java x.y.z-oracle
```

#### Java SE Development Kit(JetBrains)

```
sdk install java x.y.z-jbr
```