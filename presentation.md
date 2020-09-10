---
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
marp: true
backgroundImage: url('https://marp.app/assets/hero-background.jpg')
---

# **Testing ESXi Infrastructure**

Pester Testing Using PowerShell and PowerCLI

---

# About Bill Kindle

- Cyber Security Engineer / SysAdmin / vExpert 2020
- Blogger / Author / Editor
  - The PowerShell Conference Book vol. 2-3
  - AdamTheAutomator.com
- Likes trains
- Husband to a loving wife and two tiny humans.

![bg left:40% 80%](https://avatars3.githubusercontent.com/u/7315466?s=460&u=7da1399325c85bdbf61d8ac87babecfd45cd3989&v=4)

---

![bg](https://i.imgur.com/p6j3n1t.jpg)

<!--
There are two little kids in this photo. My son and I, in the cab of the famous "Nickel Plate Road #765" Berkshire S2 Class steam locomotive built by the Lima Locomotive Works over 76 years ago. This engine is owned and operated by the Fort Wayne, IN historical society. It's an impressive machine and a thing of engineering beauty.
-->

---

# Prerequisites to Follow Along

- Access to a ESXi host
- PowerShell 5.1 / 7.0
- Basic PowerShell / PowerCLI skills
- Willingness to learn and experiment 

<!--
You don't have to follow along but I do provide some example code in my github repository.
-->

---

# Why Testing Your Infrastructure is Important
<hr>

- **Reduces human error**
- Saves *money* & *time*
  - Reduces troubleshooting overhead 
- It's the right thing to do!

![bg right:40% 80%](https://willlukang.files.wordpress.com/2014/12/play-nicely.jpg)

<!--
Why testing is important

Humans make mistakes, testing helps to discover these mistakes and enables us to mitigate them.

Mistakes can cost money and time. REPEATING THE SAME MISTAKES is not acceptable. Testing for those past mistakes helps reduce troubleshooting overhead by eliminating known possibilities of past mistakes.

Do the right thing becuase it's the right thing to do. Testing is the right thing.
-->

---

# How Can You Test ESXi Infrastructure?

<hr>

- By using a built-in Windows PowerShell module called **Pester** with PowerCLI

![bg right:40% 80%](https://awo.aws.org/wp-content/uploads/2017/03/Computer-Based-Testing-BLOG-IMAGE-3-17.jpg)

<!--
Pester isnt' just for testing PowerShell / PowerCLI code. You can test infrastructure as well! If PowerShell or PowerCLI can reach it, Pester can test it!
-->

---

# What is Pester?
<hr>

- Pester is the **ubiquitous testing framework for PowerShell**
- **Domain Specific Language** (DSL) with an easy to understand syntax
- **Built-in** with **Windows PowerShell**
- **It's not just for testing code!**

<!--
Pester provides a framework that validates expected states.
-->

![bg right](https://th.bing.com/th/id/OIP.4NYm8r2sSoGIDs_bZv5UzwHaHb?pid=Api&rs=1)

---

# What Does Pester Do?
<hr>

- **Test PowerShell / PowerCLI code**
  - Make sure code **does only what it's supposed to do.**

- **Test and validate** physical or virtual IT infrastructure **is within acceptable parameters.**

<!--
You may need to use the AllowClobber parameter for Install-Module which will install the latest version alongside older versions.
-->

---

# How to Get Pester

- Download and save directly from PowerShell Gallery:
`Save-Module -Name ‘Pester’ -Path ‘.\’Save-Module 'Pester'`

- Install the module directly to your system from PowerShell Gallery:
`Install-Module -Name ‘Pester’`

- Update the module built-into PowerShell 5.1:
`Update-Module -Name ‘Pester’`


---
<!-- _class: lead -->

# Basic Pester Syntax and Structure

---

# Describe Block { }
<hr>

*Describes* top level grouping of tests.

Think of Describe Blocks as domain specific test grouping. 

Examples:

- Network configuration parameters
- Host configuration parameters
- Service configuration parameters

---

# Context Block { }
<hr>

*Context* is the scope within a group of tests.

Think of Context Blocks as scope specific groups of tests

Examples:

- TCP/IP stack
- Host status
- Service status

---

# Assertion Blocks { }
<hr>

You run a test and **assert** an expected value*. You will see terms such as `It 'test name' {code | ShouldBe -Exactly 'value'}`

This is where you use PowerShell / PowerCLI code to build a simple test that will return a value.

The value is <font color="green">**$True**</font> (Green)

or

The value is <font color="red">**$False**</font> (Red)


---

# Tags
<hr>

VMware + Tags = ![w:50 h:50](https://i.imgur.com/hcPHsGp.jpg) 

Pester supports the use of tags. What this means is that you don't *have to have* a dozen or more individual test scripts clogging up your repo, but can keep a single test file containing all the Pester tests your heart desires. 

Call certain tags using this syntax:
`Invoke-Pester -Script .\ESXiServices.tests.ps1 -Tag 'Network'`

---

![bg right:100% 100%](https://i.imgur.com/bArAbCJ.png)

---

# What is Needed to Run a Pester Test?

- The module is already built into Windows PowerShell 5.1 (version 4 / PowerShell Gallery has version 5)
  - Windows 10, Windows Server 2016/2019
  - Will work under PowerShell 7 too!
- A test script saved with the extension ***.tests.ps1**

---

# Running a Pester Test
<hr>

- v4 way
  - `Invoke-Pester -Script '[script]' -Tag '[tag]'`
- v5 way
  - `Invoke-Pester -Path .\ESXiServices.tests.ps1 -Output Detailed`
  or
  - `.\ESXiServices.tests.ps1`

There's only a slight difference between these two, mostly just pass/fail count and execution time information. 

---

<!-- _class: lead -->

# Demo Time


Real world infrastructure testing with Pester

```PowerShell
PS:> Invoke-Pester -Path .\ESXiServices.tests.ps1 -Detailed
```

---

<!--
_backgroundImage: none
_backgroundColor: black
_color: white
-->

# Example Checklist for a ESXi 7 Deployment
<hr>

  1. NTP Daemon policy is ON.
  2. NTP Daemon is RUNNING.
  3. NTP Daemon is NOT REQUIRED.

You can use this simple checklist to build a simple test.

---

<!--
_backgroundImage: none
_backgroundColor: black
_color: white
-->

# Validation Testing Using Pester
<hr>

Filename: <font color="yellow">**ESXiServices.tests.ps1**</font>

```
Describe 'ESXi 7 Host Deployment Checklist Testing' {
    Context 'NTP Tests' -Tag 'Services' {
        It 'NTP Daemon Policy is ON' {
            $ntpd = (Get-VMHostService | Where-Object -Property Key -EQ 'ntpd')
            $ntpd.Policy | Should -BeExactly 'on'
        } # End Assertion Block
    } # End Context Block
} # End Describe Block
```

---
<!--
_backgroundImage: none
_backgroundColor: black
_color: white
-->

# Validation Testing Using Pester (Cont.)
<hr>

Filename: <font color="yellow">**ESXiServices.tests.ps1**</font>

```
        It 'NTP Daemon Running is FALSE' {
            $ntpd = (Get-VMHostService | Where-Object -Property Key -EQ 'ntpd')
            $ntpd.Running | Should -BeExactly 'False'
        } # End Assertion Block

        It 'NTP Daemon Required is FALSE' {
            $ntpd = (Get-VMHostService | Where-Object -Property Key -EQ 'ntpd')
            $ntpd.Required | Should -BeExactly 'False'
        } # End Assertion Block
```

---

<!--
_backgroundImage: none
_backgroundColor: black
_color: white
-->

# Pester in Action
<hr>

Filename: <font color="yellow">**ESXiServices.tests.ps1**</font>

![w:1200 h:425](https://i.imgur.com/4Yp1qWM.png)

---

<!--
_backgroundImage: none
_backgroundColor: black
_color: white
-->

# Pester in Action (Cont.)
<hr>

## What you saw in the previous slide:

**1.** Pester will search current directory for any *.tests.ps1 files if you do not explicitly name one. The `-Detailed` will show you everything, not just failures.
**2.** Test begins to run.
**3.** Failures will show you a full error message.
**4.** What success looks like.
**5.** Test completion messages.

---

<!--
_backgroundImage: none
_backgroundColor: black
_color: white
-->

# Recorded Demo (real-time)
![w:1150 h:500](https://i.imgur.com/yR4urPg.gif)

<!--
I recorded this in real time to show just how fast you can complete a suite of tests with Pester. 

In Milliseconds. YMMV though depending on how efficient your code is at returning information.
-->
---

# Takeaways

- Pester is **not just for code testing.**
- Tests can be *simple* or *complex*. The choice is yours.
- Pester **makes use of your existing knowledge** of PowerShell / PowerCLI 
- Pester **enables you** to test all aspects of your infrastructure systems quickly. From workstations to servers, hypervisors, or network devices, if PowerShell / PowerCLI can reach it, Pester can test it.

---

<!-- _class: lead -->

# Ways to Learn More

---

[The Pester Book](https://leanpub.com/pesterbook) < The book that started it all for me.

[PSKoans](https://github.com/vexx32/PSKoans
) < Uses Pester to teach PowerShell interactively.

[Infrastructure Testing Using Pester](https://adamtheautomator.com/infrastructure-testing-pester/) < A blog on how I used Pester for infrastructure testing.

[Pester GitHub](https://github.com/pester/Pester) < Code repo

[Official Pester Website](https://pester.dev/)

<!--
Reminder to recommend supporting the Pester Developers through GitHub.
-->

---

<!-- _class: lead -->

# Happy Testing!

Access this presentation and code examples using QR code below:

![Imgur](https://i.imgur.com/so8nGqj.png)

<!--
Special thanks to you, the viewer and to the team at VMware Code{} Connect for all the help in making this first time presentation at a major online conference possible for this first time vExpert!
-->