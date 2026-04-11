# iBeam-Scanner

Proximity-aware Flutter app scaffold organized for Clean Architecture, Bloc state management, and a dedicated iBeacon wrapper package.

## Folder Structure

```text
lib/
	main.dart
	src/
		app/
			app.dart
			di/
				injector.dart
			routes/
				app_routes.dart
		core/
			constants/
			error/
			services/
			utils/
			presentation/
				widgets/
					custom_button.dart
					stat_card.dart
		features/
			app_shell/
				presentation/
					pages/
						main_layout.dart
					widgets/
						custom_app_bar.dart
						custom_bottom_nav.dart
			auth/
				data/
					datasources/
					models/
					repositories/
				domain/
					entities/
					repositories/
					usecases/
				presentation/
					bloc/
					pages/
						login_screen.dart
					widgets/
			permissions/
				data/
					datasources/
					models/
					repositories/
				domain/
					entities/
					repositories/
					usecases/
				presentation/
					bloc/
					pages/
						setup_permission_screen.dart
					widgets/
			beacon_scanner/
				data/
					datasources/
					models/
					repositories/
				domain/
					entities/
					repositories/
					usecases/
				presentation/
					bloc/
					pages/
						dashboard_screen.dart
					widgets/
			alerts/
				data/
					datasources/
					models/
					repositories/
				domain/
					entities/
					repositories/
					usecases/
				presentation/
					bloc/
					pages/
						refined_alerts_screen.dart
					widgets/
			settings/
				data/
					datasources/
					models/
					repositories/
				domain/
					entities/
					repositories/
					usecases/
				presentation/
					bloc/
					pages/
						settings_screen.dart
					widgets/

packages/
	ibeacon_wrapper/
		lib/
			ibeacon_wrapper.dart
			src/
				contracts/
					ibeacon_scanner.dart
				entities/
					beacon_signal.dart
					scanner_status.dart
				utils/
					distance_estimator.dart
```

## Why This Structure

- Features are vertical slices with clear `data`, `domain`, and `presentation` boundaries.
- Shared UI primitives are in `core/presentation/widgets`.
- App shell concerns (routing, bootstrapping, layout shell) are isolated in `app` and `features/app_shell`.
- iBeacon scanning is abstracted into a dedicated local package (`packages/ibeacon_wrapper`) so domain logic is independent from any specific scanning plugin.

## Notes

- Existing UI files were preserved and only relocated to match the architecture.
- Route names are centralized in `app_routes.dart`.
- Analysis status: `flutter analyze` passes with no issues.
