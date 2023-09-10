# Interactive error handling for your PowerShell script
- `Handle-Interactively` provides you with a **simple option for suspending a script whenever an error occurs**
- it then **allows you to jump in interactively** to rectify the situation and let the **script continue where it left off afterwards** (without having to start it anew)
- you don't have to pipe each command that should be wrapped this way into the function provided by me individually
- instead, **`Handle-Interactively` expects to receive a script-block** (just wrap the selected commands in curly braces), as [shown below](#example-code)
  - you could wrap entire parts of a script
  - or even the contents of a whole file altogether
  - then just pipe that into the function
  - thus, the verbosity/amount of required overhead in terms of syntax is kept to a minimum

https://github.com/luis261/posh-interactive-handling/blob/main/interactive-handling-usage-example.mp4

## Why would anyone ever want that?
First of all, it can be **very useful when prototyping larger scripts**. Besides that though, the general applicability of the described functionality is admittedly somewhat niche.
For example, you would not want your Webserver to suspend the execution of your code in case of an error and make the user wait for someone to manually intervene, right? Instead you'd just expect the user to receive an error code, as well as ideally receiving a report via some sort of monitoring construct so the issue can be taken care of asynchronously irrespective of the direct response to the request that caused the issue/made the bug apparent (I hope you're using something a bit more "proper" than Powershell to run Webservices anyway 😅).
The same is true for a good portion of the typical automation scripts Ops personnel uses for day-to-day automation tasks right?
But in my experience, there is also another kind of script, often just as pervasive, at least in terms of the time spent on running and maintaining them.
The kind I'm talking about is **highly specific to a certain task and usually gets triggered manually** instead of having an automated binding to the consumer; it **might only get executed every few weeks or even months. But when it does run, it has to work and help you perform your duty reliably. Especially when dealing with long scripts interacting with unreliable dependencies undergoing frequent and often unregulated changes, no matter how defensively you write your code, they might still break every once in a while**. This is where the proposed interactive error handling functionality can save the day by preventing repeated runs of long scripts, which is especially important in case they have side effects with serious implications.

below are a few **examples of scripts I consider to be candidates that could particularly profit from the usage of interactive error handling**:
- a **script that resets the krbtgt password** in a certain domain
- provisioning **scripts performing fiddly setup tasks and interacting with unreliable tooling**

## Example code
```powershell
{
    $a = 0
    $b = 10/0 # command causing error, this is obviously just a token example, imagine a command interacting with an unstable external dependency instead
    Write-Host "The previous state resulting by the previously executed commands of the script is conserved, as evidenced by the value of a: $a"
    Write-Host "Here's the value of b: $b - assuming you set it interactively during handling of the previous error, it should not be empty, so further commands in this script block relying on it could run without any problems"
} | Handle-Interactively
```

## Caveats
- the current implementation is quite hacky (though arguably that's what powershell is all about 😝)
- it **can't handle multi-line commands**

## What's next
- I'll publish this as a proper module to the Gallery, but only if people actually ask for it
- other than that, it's really up to you reading this right now, feel free to get involved if you find something wrong or have ideas beyond my current vision
