# Create a command to download the database from a connected device or emulator.
# Usage: flutter make download-db
# Make sure to replace 'com.example.fitsanny' with your actual app package name.
# The database file will be saved in the 'assets' directory of your Flutter project.
download-db:
	adb exec-out run-as com.example.fitsanny cat databases/fitsanny.db > assets/fitsanny.db
