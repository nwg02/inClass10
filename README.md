# GuildQuest — MAD 4360 Activity 10

## Project Information

- **Student:** Nick Gilreath
- **Course:** MAD 4360
- **Activity:** In-Class Activity 10 — Flutter Signup Form Quest
- **Track:** Undergraduate
- **App:** GuildQuest — MMO guild signup demo
- **Task:** Core signup form and Task A (Guildmaster Signup Coach)
- **Project Type:** Individual

## App Description

GuildQuest is a fantasy-themed MMO guild signup screen built with Flutter. It includes character name, email, and password fields with local validation, success feedback, and a Guildmaster Signup Tip feature.

The app uses a dark purple theme with gold accents to match its fantasy RPG aesthetic. The signup is a demonstration only; it does not create or store an account.

## AI Signup Coach

The app implements the required signup-tip flow using a deterministic mock because no instructor-provided endpoint URL or access instructions were available during development.

The request contract uses the following non-sensitive fields:

- `task`: `signup_tip`
- `topic`: `password_help`

The request does not include the character name, email, password, or other personal form information.

The mock displays a password tip, identifies the response as mock output, and explains that no live AI model was called. The feature is separate from local form validation and does not determine whether signup is accepted.

## Undergraduate Reflection

### Question 1: Trace the AI tip feature from button tap to displayed text. Which widget/state changes while the request is waiting, and how does the user recover if it fails?

When the user taps Get a Signup Tip, the `_getGuildTip()` method sets `_loadingTip` to true and displays a loading indicator while the service runs. When the request succeeds, the app displays the tip as text; if it fails, the app displays an error message and a Try Again button. The user can tap Try Again to repeat the request.

### Question 2: Name the exact information your request sends and one piece of information it deliberately does not send. Why?

The request contract sends the fixed task label `signup_tip` and the topic `password_help`. It deliberately excludes the character name, email address, and password because these details are unnecessary to generate general password advice. This reduces the amount of personal information exposed to the AI service.

## Testing

Update this checklist to reflect the tests actually completed.

- [x] Empty form displays validation errors.
- [x] Invalid email displays an error.
- [x] Password shorter than six characters displays an error.
- [x] Valid form input displays success feedback.
- [x] Guildmaster mock tip displays successfully.
- [x] Failure/offline state displays a friendly error and retry option.
- [x] Release APK builds successfully.

## Individual Contribution

### Nick Gilreath

Individually developed the GuildQuest Flutter signup application, including the fantasy-themed interface, form validation, signup feedback, and Guildmaster Signup Tip mock feature. Tested the form and mock tip functionality and documented the implementation and its limitations.

## Limitations

The signup is a demonstration and does not create an account. The current Guildmaster tip uses a deterministic mock rather than a live AI model because no instructor endpoint was available. The tip is general guidance, not a guarantee of password security or a decision about signup validity.
