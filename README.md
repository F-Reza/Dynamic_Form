# Dynamic Form App

## Features

- **Form List Page**: Displays a list of available forms.
- **Form Page**: Dynamically renders forms configuration.
- **Submission View Page**: Displays submitted form data and saves it to the device's storage.

## Dependencies

- `provider`: For state management.
- `path_provider`: To access the device's storage.
- `image_picker`: To pick images from the gallery or camera.

## Setup

1. Clone the repository.
2. Run `flutter pub get` to fetch dependencies.
3. Run the app using `flutter run`.

## Project Structure

- `lib/screens`: Pages of the application.

## Usage

1. Open the app to view the list of forms.
2. Tap on a form to fill it out.
3. Submit the form to view the submission details.
4. Save the submission to the device's storage.

## Configuration

Forms are configured using JSON. Each form consists of sections, and each section consists of fields. The field type is determined by the `id` property:

- `1`: TextField
- `2`: List (dropdown or checkbox)
- `3`: Yes/No/NA
- `4`: Image (camera/gallery)
