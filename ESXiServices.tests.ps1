# Validation testing example from slide 18
Describe 'ESXi 7 Host Deployment Checklist Testing' {

    Context 'NTP Tests' -Tag 'Services' {

        It 'NTP Daemon Policy is ON' {

            $ntpd = (Get-VMHostService -VMHost $VMhost | Where-Object -Property Key -EQ 'ntpd')

            $ntpd.Policy | Should -BeExactly 'on'

        } # End Assertion Block

        # Example of how you must remember how to assert your expected state to get the right results!
        It 'NTP Daemon Running is FALSE' {

            $ntpd = (Get-VMHostService -VMHost $VMhost | Where-Object -Property Key -EQ 'ntpd')

            $ntpd.Running | Should -BeExactly 'False'

        } # End Assertion Block

        It 'NTP Daemon Required is FALSE' {

            $ntpd = (Get-VMHostService -VMHost $VMhost | Where-Object -Property Key -EQ 'ntpd')

            $ntpd.Required | Should -BeExactly 'False'

        } # End Assertion Block

    } # End Context Block

} # End Describe Block

# Validation testing example from slide 19