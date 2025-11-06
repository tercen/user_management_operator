# user_management

A new Flutter project.

## Getting Started

- Search for user
- Add user
- Edit user
- Delete user
- View user details
- Disable user
- Enable user

## Implementation

- Provide an abstract user service class.

## Run

```shell
source ~/.asdf/asdf.sh && 

TERCEN_TOKEN=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3RlcmNlbi5jb20iLCJleHAiOjE3NjQ4NjE0MjcsImRhdGEiOnsiZCI6IiIsInUiOiJ0ZXN0IiwiZSI6MTc2NDg2MTQyNzAxOH19.bYBUclox8y4gWLbHpuYalhrlFdSHVH80Be2MJ-qrVmI

flutter run -d web-server --web-hostname=127.0.0.1 \
  --web-port=12888 \
  --dart-define=TERCEN_TOKEN=$TERCEN_TOKEN \
  --dart-define=SERVICE_URI=http://127.0.0.1:5400 \
  --profile \
  --wasm
 
flutter run -d web-server --web-hostname=127.0.0.1 \
  --web-port=12888 \
  --dart-define=PROJECT_ID=8af67c605f21a18cc1450135350a5c7b \
  --dart-define=SERVICE_URI=http://127.0.0.1:5400 \
  --dart-define=TERCEN_TOKEN=$TERCEN_TOKEN \
  --profile


flutter build web --wasm
```
