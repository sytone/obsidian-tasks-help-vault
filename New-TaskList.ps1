

function New-IgLoremIpsum {
    <#
    .Synopsis
        Creates Lorem Ipsum paragraphs.
    .Description
        User inputs how many paragraphs or words they need they need, defaults to 5 paragraphs.
        Then, foreach paragraph generates a number of sentences between 4 and 10.
        And foreach sentence, generates a number of words that are 4 to 10 characters long.
        Then foreach word, randomly generates the letters.
        The first letter of the sentences are capitalized and the very first words are "Lorem Ipsum"

        You cannot request more than 100 paragraphs or 5000 words. This won't be an exact number
        due to the randomness of the script, but it'll be sorta close.
    .Example
        New-IgLoremIpsum
        This will generate 5 paragraphs of Lorem Ipsum.
    .Example
        New-IgLoremIpsum -Paragraphs 10
        This will generate 10 paragraphs of Lorem Ipsum.
    .Inputs
        None required, but an integer of how many paragraphs or words to generate.
    .Outputs
        string
    .Notes
        Created by donn@thehouseofdonn.com
        Created on 2016-12-07
    .Link
        http://www.powershellusers.com
    .Link
        http://donnigway.wordpress.com
    #>
    [CmdletBinding(DefaultParameterSetName = 'DefParamSet',
        SupportsShouldProcess = $true,
        PositionalBinding = $false,
        ConfirmImpact = 'Medium')]
    [OutputType([String])]
    Param (
        # This is a number of how many paragraphs you want to create. Max is 100 paragraphs.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'DefParamSet')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 100)]
        [int]$Paragraphs = 5,

        # This is how words to generate. Based on how many words, the script will figure out how many paragraphs are needed. The maximum number of words to tell the script is 5000.
        [Parameter(Mandatory = $true,
            ParameterSetName = 'ParamSet2')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(3, 5000)]
        [int]$Count,

        # This will NOT send any output to the screen, but send the output directly to the clipboard.
        # Useful if you want to put the output into another medium.
        [switch]$SendToClipBoard
    )
    Begin {
        Function Get-IgCurrentLineNumber {
            # Simply Displays the Line number within the script.
            [string]$line = $MyInvocation.ScriptLineNumber
            $line.PadLeft(4, '0')
        }

        # List of letters I wanted to get randomness from.
        # Yes there are better ways, but to show examples and simplify...
        $list = @('a', 'a', 'b', 'c', 'd', 'e', 'e', 'f', 'g', 'h', 'i', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'o', 'p', 'q', 'r', 's', 't', 'u', 'u', 'v', 'w', 'x', 'y', 'z')

        if ($PSBoundParameters.ContainsKey('Count')) {
            [int]$Paragraphs = [int](($Count + 200) / 80)
            Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Paragraphs from Count: $Paragraphs"
        }
    }
    Process {
        [string]$allLoremIpsum = @()
        $totalWords = 0
        $FirstParagraph = $true

        #region Looping thru each Paragraph.
        for ($p = 1; $p -lt ($Paragraphs + 1); $p++) {
            Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Paragraph '$p'"
            [string]$currentParagraph = @()

            #region Figure out the number of sentences
            $sentencesInParagraph = Get-Random -Minimum 4 -Maximum 18
            for ($s = 1; $s -lt ($sentencesInParagraph + 1); $s++) {
                Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]   Sentence '$s'"
                [string]$currentSentence = @()

                #region Figure out how many words are in the sentence
                $wordsInSentence = Get-Random -Minimum 4 -Maximum 18
                #[int]$WordCountInSentence = 0
                for ($w = 1; $w -lt ($wordsInSentence + 1); $w++) {

                    Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]     Word '$w'"
                    [string]$currentWord = @()

                    #region Adding Letters to words
                    if ($p -eq 1 -and $s -eq 1 -and $w -eq 1) {
                        # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]     Lorem Ipsum"
                        # $currentWord += 'Lorem Ipsum'
                        $currentWord += ''
                        $totalWords += 2
                    } else {
                        for ($l = 1; $l -lt ((Get-Random -Minimum 4 -Maximum 10) + 1); $l++) {
                            if ($w -eq 1 -and $l -eq 1) {
                                $currentLetter = ($list | Get-Random).ToUpper()
                                # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]       Letter '$l' '$currentLetter'"
                            } else {
                                $currentLetter = $list | Get-Random
                                # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]       Letter '$l' '$currentLetter'"
                            }
                            $currentWord += $currentLetter
                        }
                        $totalWords++

                    } # ending adding letters to words
                    #endregion

                    if ($currentWord -ne 'Lorem Ipsum') {
                        $currentWord = ($currentWord -replace '[^\w]', '')
                    }

                    if ($PSBoundParameters.ContainsKey('Count')) {
                        if ($totalWords -eq $Count) {
                            Write-Verbose -Message "[Line: $(Get-IgCurrentLineNumber)] I want to stop. Now!"
                            $currentWord = " $currentWord."

                            # Chaning Values to something bigger than the loops
                            $w = $wordsInSentence + $w
                            $s = $sentencesInParagraph + $s
                            $p = $Paragraphs + $p
                        } else {
                            if ($w -eq $wordsInSentence) {
                                # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Period"
                                $currentWord = " $currentWord."
                            } else {
                                # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Space"
                                if ($w -eq 1 -and $s -eq 1) {
                                    $currentWord = "$currentWord"
                                } else {
                                    $currentWord = " $currentWord"
                                }
                            }
                        }
                    } else {
                        if ($w -eq $wordsInSentence) {
                            # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Period"
                            $currentWord = " $currentWord."
                        } else {
                            # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Space"
                            if ($w -eq 1 -and $s -eq 1) {
                                $currentWord = "$currentWord"
                            } else {
                                $currentWord = " $currentWord"
                            }
                        }
                    }

                    Write-Debug -Message 'Ending Word'

                    # Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]     Current Word: '$currentWord'"
                    $currentSentence += $currentWord

                } # ending words
                #endregion

                Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]   Current Sentence: $currentSentence"
                Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]   Current Words In Sentence: $wordsInSentence"

                Write-Verbose "[Line: $(Get-IgCurrentLineNumber)]   Total Words: $totalWords"
                $currentParagraph += $currentSentence
                Write-Debug -Message 'Ending Sentence'
            } # ending Sentences
            #endregion

            if ($FirstParagraph) {
                Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] First PP"
                $allLoremIpsum = @"
$currentParagraph
"@
                $FirstParagraph = $false
            } else {
                Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Not first PP"
                $allLoremIpsum += @"

$currentParagraph
"@
                Write-Debug -Message 'Ending Paragraph'
            }
        } # ending paragraph
        #endregion

    }
    End {
        Write-Verbose "[Line: $(Get-IgCurrentLineNumber)] Output Total Words: $totalWords"
        if ($SendToClipBoard) {
            $allLoremIpsum | Set-Clipboard
        } else {
            $allLoremIpsum
        }
    }
}

function Get-RandomDateBetween {
    <#
    .EXAMPLE
    Get-RandomDateBetween -StartDate (Get-Date) -EndDate (Get-Date).AddDays(15)
    #>
    [Cmdletbinding()]
    param(
        [parameter(Mandatory = $True)][DateTime]$StartDate,
        [parameter(Mandatory = $True)][DateTime]$EndDate
    )

    process {
        return Get-Random -Minimum $StartDate.Ticks -Maximum $EndDate.Ticks | Get-Date -Format 'yyyy-MM-dd'
    }
}


function Get-RandomTimeBetween {
    <#
    .EXAMPLE
    Get-RandomTimeBetween -StartTime "08:30" -EndTime "16:30"
    #>
    [Cmdletbinding()]
    param(
        [parameter(Mandatory = $True)][string]$StartTime,
        [parameter(Mandatory = $True)][string]$EndTime
    )
    begin {
        $minuteTimeArray = @('00', '15', '30', '45')
    }
    process {
        $rangeHours = @($StartTime.Split(':')[0], $EndTime.Split(':')[0])
        $hourTime = Get-Random -Minimum $rangeHours[0] -Maximum $rangeHours[1]
        $minuteTime = '00'
        if ($hourTime -ne $rangeHours[0] -and $hourTime -ne $rangeHours[1]) {
            $minuteTime = Get-Random $minuteTimeArray
            return "${hourTime}:${minuteTime}"
        } elseif ($hourTime -eq $rangeHours[0]) {
            # hour is the same as the start time so we ensure the minute time is higher
            $minuteTime = $minuteTimeArray | Where-Object { [int]$_ -ge [int]$StartTime.Split(':')[1] } | Get-Random # Pick the next quarter
            #If there is no quarter available (eg 09:50) we jump to the next hour (10:00)
            return (. { If (-not $minuteTime) { "${[int]hourTime+1}:00" }else { "${hourTime}:${minuteTime}" } })

        } else {
            # hour is the same as the end time
            #By sorting the array, 00 will be pick if no close hour quarter is found
            $minuteTime = $minuteTimeArray | Sort-Object -Descending | Where-Object { [int]$_ -le [int]$EndTime.Split(':')[1] } | Get-Random
            return "${hourTime}:${minuteTime}"
        }
    }
}

$tasks = @(
    'Play Petanque Indoors',
    'Fold a Paper Frog',
    'Mindful Breathing Meditation',
    'Listen to Music from Your Childhood',
    'Listen to the #1 Charted Song from the Day of Your Birth',
    'Look at Your Old Photos',
    'Draw a Self-Portrait',
    'Contact a Friend Abroad',
    'Ask a Friend How Theyre Doing',
    'Play Among Us',
    'Play Skribbl.io Online (Draw and Guess)',
    'Do Jigsaw Puzzles at JigSawPuzzles.io',
    'Do Yoga',
    'Watch an Animal Livestream',
    'Sign a Petition',
    'Complete a Sudoku',
    'Find Things to Give Forward',
    'Do a Body Scan Meditation',
    'Exercise',
    'Research Dolphins',
    'Donate to a Charity',
    'Take a Virtual Museum Tour',
    'Rearrange Your Room',
    'Scan Your Computer for Viruses',
    'Solve a Logic Puzzle',
    'Write a Haiku',
    'Stretch',
    'Install Blue Light Filters on Your Devices',
    'Write Fanmail to Someone You Admire',
    'Make Paper Airplanes',
    'Create a Playlist',
    'Create a Playlist of Foreign Music',
    'Read a Random Wikipedia Article',
    'Play Geoguessr',
    'Tape Pictures of your Five Favourite Things at Home',
    'Tape Photos of Beautiful Fabrics and Patterns at Your Home',
    'Look out of the Window for 3 Minutes',
    'Learn Your Name in Sign Language',
    'Check Whats on the Opposite Side of Earth',
    'Unsubscribe from Unnecessary Emails',
    'Learn a Magic Trick',
    'Smile in the Mirror',
    'Look at the Details of Your Eyes',
    'Post positive feedback on a YouTube Video',
    'Write Positive Feedback to a Musician',
    'Create a Stop Motion Animation',
    'Make Plans for the Future',
    'Do an IPIP-NEO Personality Pest.',
    'Check Your Home on Google Street View',
    'Check If Your Name Means Something in Another Language',
    'Calculate Your Carbon Emissions',
    'Contact a Relative',
    'Watch an Old Cartoon',
    'Have a Cold Shower',
    'Read a Random WikiHow Article',
    'Study the History of a Random Country',
    'Check Which Celebrities Share Your Birthday',
    'Count the Power Sockets in Your House',
    'Uninstall Unnecessary Apps',
    'Loving-Kindness Meditation',
    'Learn to Tie Your Shoelaces in a New Way',
    'Watch a Eurovision Performance',
    'Remove Spoilt Food from Your Fridge',
    'Watch This Restored Video from 1902',
    'Find Something Interesting on This Website',
    'Post Something in the Comments Below',
    'Share Your Own Idea',
    'Do a Dance Cardio Workout'
)

$priority = @('', ' ⏫', ' 🔼', ' 🔽')
$dueIcon = ' 📅'
$reoccuranceIcon = ' 🔁'
$scheduledIcon = ' ⏳'
$startIcon = ' 🛫'

$tags = @(
    ' #DeepWork',
    ' #ShallowWork',
    ' #Chores',
    ' #Learning',
    ' #MindCare',
    ' #BodyCare',
    ' #People',
    ' #NextWeek',
    ' #Context/Work',
    ' #Context/Life',
    ' #Context/Home',
    ' #Context/Family',
    ' #Context/Friends',
    '',
    '',
    ''
)

$totalTasks = 100
$tasksList = @()


# Due Today
for ($taskCount = 0; $taskCount -lt 3; $taskCount++) {
    $taskDescription = New-IgLoremIpsum -Count 5
    $taskDescription = $tasks[(Get-Random -Maximum $tags.Length -Minimum 0)]
    $priorityIcon = $priority[(Get-Random -Maximum 4 -Minimum 0)]
    $dueDate = (Get-Date).ToString('yyyy-MM-dd')
    $taskTags = $tags[(Get-Random -Maximum $tags.Length -Minimum 0)]

    $tasksList += "- [ ] $taskDescription$taskTags$priorityIcon$(("$dueIcon $dueDate",'')[(Get-Random -Maximum 2 -Minimum 0)])$(("$scheduledIcon $scheduledDate",'')[(Get-Random -Maximum 2 -Minimum 0)])$(("$startIcon $startDate",'')[(Get-Random -Maximum 2 -Minimum 0)])"
}


# Due Tomorrow
for ($taskCount = 0; $taskCount -lt 3; $taskCount++) {
    $taskDescription = New-IgLoremIpsum -Count 5
    $taskDescription = $tasks[(Get-Random -Maximum $tags.Length -Minimum 0)]
    $priorityIcon = $priority[(Get-Random -Maximum 4 -Minimum 0)]
    $dueDate = ((Get-Date).AddDays(1)).ToString('yyyy-MM-dd')
    $taskTags = $tags[(Get-Random -Maximum $tags.Length -Minimum 0)]

    $tasksList += "- [ ] $taskDescription$taskTags$priorityIcon$(("$dueIcon $dueDate",'')[(Get-Random -Maximum 2 -Minimum 0)])$(("$scheduledIcon $scheduledDate",'')[(Get-Random -Maximum 2 -Minimum 0)])$(("$startIcon $startDate",'')[(Get-Random -Maximum 2 -Minimum 0)])"
}

# Due Next Week
for ($taskCount = 0; $taskCount -lt 3; $taskCount++) {
    $taskDescription = New-IgLoremIpsum -Count 5
    $taskDescription = $tasks[(Get-Random -Maximum $tags.Length -Minimum 0)]
    $priorityIcon = $priority[(Get-Random -Maximum 4 -Minimum 0)]
    $dueDate = (Get-RandomDateBetween -StartDate ((Get-Date).AddDays(7)) -EndDate ((Get-Date).AddDays(14)))
    $taskTags = $tags[(Get-Random -Maximum $tags.Length -Minimum 0)]

    $tasksList += "- [ ] $taskDescription$taskTags$priorityIcon$(("$dueIcon $dueDate",'')[(Get-Random -Maximum 2 -Minimum 0)])$(("$scheduledIcon $scheduledDate",'')[(Get-Random -Maximum 2 -Minimum 0)])$(("$startIcon $startDate",'')[(Get-Random -Maximum 2 -Minimum 0)])"
}

# Random
for ($taskCount = 0; $taskCount -lt $totalTasks; $taskCount++) {
    $taskDescription = New-IgLoremIpsum -Count 5
    $taskDescription = $tasks[(Get-Random -Maximum $tags.Length -Minimum 0)]
    $priorityIcon = $priority[(Get-Random -Maximum 4 -Minimum 0)]
    $dueDate = (Get-RandomDateBetween -StartDate (Get-Date) -EndDate ((Get-Date).AddDays(90)))
    $scheduledDate = (Get-RandomDateBetween -StartDate (Get-Date) -EndDate ((Get-Date).AddDays(90)))
    $startDate = (Get-RandomDateBetween -StartDate (Get-Date) -EndDate ((Get-Date).AddDays(90)))
    $taskTags = $tags[(Get-Random -Maximum $tags.Length -Minimum 0)]

    $tasksList += "- [ ] $taskDescription$taskTags$priorityIcon$(("$dueIcon $dueDate",'')[(Get-Random -Maximum 2 -Minimum 0)])$(("$scheduledIcon $scheduledDate",'')[(Get-Random -Maximum 2 -Minimum 0)])$(("$startIcon $startDate",'')[(Get-Random -Maximum 2 -Minimum 0)])"
}

$header = @'
# Random Tasks

This is generated from the powershell script.

'@

"$header`n$($tasksList -join "`n")" | Set-Content -Path './List of random tasks.md'