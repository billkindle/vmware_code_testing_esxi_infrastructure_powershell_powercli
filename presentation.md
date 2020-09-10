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

- Cyber Security Engineer / SysAdmin
- Blogger / Author / Editor
  - The PowerShell Conference Book vol. 2-3
  - AdamTheAutomator.com
- Loves model railroading and trains
- Husband to a loving wife and two tiny humans.


![bg left:40% 80%](https://avatars3.githubusercontent.com/u/7315466?s=460&u=7da1399325c85bdbf61d8ac87babecfd45cd3989&v=4)

---

# Prerequisites to Follow Along

- Access to a ESXi host
- PowerShell 5.1 / 7.0
- Basic PowerShell / PowerCLI skills
- Willingness to learn and experiment 

---

# Why Testing Your Infrastructure is Important
<hr>

- **Reduces human error**
- Saves *money* & *time*
  - Reduces troubleshooting overhead 
- It's the right thing to do!

![bg right:40% 80%](https://willlukang.files.wordpress.com/2014/12/play-nicely.jpg)

---

# How Can You Test ESXi Infrastructure?

<hr>

- By using a built-in Windows PowerShell module called **Pester** with PowerCLI

![bg right:40% 80%](https://awo.aws.org/wp-content/uploads/2017/03/Computer-Based-Testing-BLOG-IMAGE-3-17.jpg)

---

# What is Pester?
<hr>

- Pester is the **ubiquitous testing framework for PowerShell**
- **Domain Specific Language** (DSL) with an easy to understand syntax
- **Built-in** with **Windows PowerShell**
- **It's not just for testing code!**

![bg right](https://th.bing.com/th/id/OIP.4NYm8r2sSoGIDs_bZv5UzwHaHb?pid=Api&rs=1)

---

# What Does Pester Do?
<hr>

- **Test PowerShell / PowerCLI code**
  - Make sure code **does only what it's supposed to do.**

- **Test and validate** physical or virtual IT infrastructure **is within acceptable parameters.**

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

# Describe Block
<hr>

*Describes* top level grouping of tests.

Think of Describe Blocks as domain specific test grouping. 

Examples:

- Network configuration parameters
- Host configuration parameters
- Service configuration parameters

---

# Context Block
<hr>

*Context* is the scope within a group of tests.

Think of Context Blocks as scope specific groups of tests

Examples:

- TCP/IP stack
- Host status
- Service status

---

# Assertion Blocks
<hr>

You run a test and **assert** an expected value*. You will see terms such as `It 'test name' {code | ShouldBe -Exactly 'value'}`

This is where you use PowerShell / PowerCLI code to build a simple test that will return a value.

The value is <font color="green">**$True**</font>

or

The value is <font color="red">**$False**</font>


---

# Tags
<hr>
VMware users like tags. 

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
  - `invoke-pester -Path .\ESXiServices.tests.ps1 -Output Detailed`
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
        # Example of how you must remember how to assert your expected state to get the right results!
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

---

<!-- _class: lead -->

# Happy Testing!