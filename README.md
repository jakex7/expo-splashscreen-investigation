# Cold Boot Time

## Boot Time Measurements

Android's `ActivityTaskManager` measures display time from the moment the process starts until the splash screen is hidden.

## Expo Splash Screen

Before Expo SDK 52, `expo-splash-screen` package were using a custom implementation, that was simulating the splash screen by showing a custom overlay that smoothly appeared after the native splash screen hides. In this setup, the measured boot time reflected only the native splash screen time.

Starting with SDK 52, we implemented Android's Splash Screen API in the `expo-splash-screen` package. That means we stopped faking the splash screen and began simply extending the native one. With this, measurements now include the time from app launch until `SplashScreen.hideAsync()` is manually called.

# Test Results

All tests were performed using the release build variant, legacy architecture and executed via the `test.sh` script.

| Test Name             | Test 1 | Test 2 | Test 3 | Average | % Difference from SDK 51 |
| --------------------- | ------ | ------ | ------ | ------- | ------------------------ |
| SDK 51                | 324    | 348    | 338    | 331     | -                        |
| SDK 53                | 314    | 247    | 283    | 298.5   | -9.82%                   |
| SDK 51 (instant hide) | 317    | 381    | 382    | 349.5   | -                        |
| SDK 53 (instant hide) | 274    | 353    | 381    | 327.5   | -6.29%                   |
| SDK 51 (delayed hide) | 285    | 338    | 293    | 289     | -                        |
| SDK 53 (delayed hide) | 2328   | 2301   | 2467   | 2397.5  | +729.58%                 |

`SDK 53 (delayed hide)` includes a **2-second** delay before calling `SplashScreen.hideAsync()`. Normally, this delay would be much shorter, as it's usually just time to load fonts, get user data from async storage, or similar tasks.

## Conclusion

While actual application boot time may remain consistent or even improve, the measured boot times reflect the extended splash screen display duration, potentially indicating misleading performance degradation.


<details>
<summary>Articles on similar issues for native apps</summary>

* https://engineering.backmarket.com/how-we-enhanced-our-android-apps-startup-time-by-over-50-0fb220d27b14
* https://proandroiddev.com/fixing-derailed-app-cold-start-metrics-5e05c1a9ab4a

</details>
