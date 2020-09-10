# Validation testing example from slides 18-19

<#
    This is a simple test that uses a basic PowerCLI cmdlet
    to connect to and check Host Services.

    Each 'It' block uses basic PowerShell / PowerCLI syntax
    to gather objects using as little code as possible.

    Those objects are stored as a variable, which then gives
    you access to membertypes. In these examples, we are using
    the `Property` membertype of `Policy`, `Running`, and `Required`.

    Doing it this way gives us single string output, which I've found
    to be the easiest way to perform a True/False comparison using Pester.

    Experiment with the code as you wish.

#>
Describe 'ESXi 7 Host Deployment Checklist Testing' {

    Context 'NTP Tests' -Tag 'Services' {

        It 'NTP Daemon Policy is ON' {

            $ntpd = (Get-VMHostService | Where-Object -Property Key -EQ 'ntpd')

            $ntpd.Policy | Should -BeExactly 'on'

        } # End Assertion Block

        # Example of how you must remember how to assert your expected state to get the right results!
        It 'NTP Daemon Running is FALSE' {

            $ntpd = (Get-VMHostService | Where-Object -Property Key -EQ 'ntpd')

            $ntpd.Running | Should -BeExactly 'False'

        } # End Assertion Block

        It 'NTP Daemon Required is FALSE' {

            $ntpd = (Get-VMHostService | Where-Object -Property Key -EQ 'ntpd')

            $ntpd.Required | Should -BeExactly 'False'

        } # End Assertion Block

    } # End Context Block

} # End Describe Block

# Validation testing example from slides 18-19