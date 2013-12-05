# Stop-Walking-iPhone
Stop-Walking-iPhone show warning on your app when texting while walking with iPhone.

# Requirements
- iOS 7 or later
- ARC
- Device include M7

# Usage

## Start/Stop

- Start

    ``` objc
    [SWIManager.sharedManager start];
    ```

- Stop

    ``` objc
    [SWIManager.sharedManager stop];
    ```

## Use original warning

``` objc
UIView *customWarning = ...
SWIManager.sharedmanager.warningView = customWarning;
```

## Set duration to show warning

``` objc
// if you want to show 5 seconds after handled walking
SWIManager.sharedmanager.seconds = 5;
```

## Notifications

- `kSWIManagerWarningWillShowNotificaiton`

    `SWIManager` will show warning. Stop your application if needed.

- `kSWIManagerWarningWillHideNotificaiton`.

    `SWIManager` will hide warning. Restart your application if needed.

# Install

## CocoaPods
```
pod 'Stop-Walking-iPhone'
```

## Manually
Drag and Drop `Stop-Walking-iPhone` directory to your project.

# Licence
MIT Licene

Copyright (c) 2013 Taiki Fukui

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
