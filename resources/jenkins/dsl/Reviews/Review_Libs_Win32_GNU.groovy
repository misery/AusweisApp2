import common.LibraryReview

def j = new LibraryReview
	(
		name: 'Win32_GNU',
		label: 'Windows'
	).generate(this)


j.with
{
	wrappers
	{
		environmentVariables
		{
			env('MSYS2_PATH_TYPE', 'inherit')
		}
	}

	steps
	{
		batchFile('cd source & python resources/jenkins/import.py')

		batchFile("cd build & cmake ../source/libs -DCMAKE_BUILD_TYPE=release -DPACKAGES_DIR=%PACKAGES_DIR% -G\"MinGW Makefiles\" -DWIN_SIGN_KEYSTORE=%WIN_SIGN_KEYSTORE% -DWIN_SIGN_KEYSTORE_PSW=%WIN_SIGN_KEYSTORE_PSW% -DWIN_SIGN_SUBJECT_NAME=%WIN_SIGN_SUBJECT_NAME%")

		shell('''\
			#!c:\\msys64\\usr\\bin\\bash --login
			cd /jenkins/$JOB_NAME/build
			mingw32-make openssl
			'''.stripIndent().trim())

		batchFile('cd build & mingw32-make compress')
	}
}
