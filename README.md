# SetDebugOptApk
Setting debugging options for apk 
<br />
OS : Windows 10
<br />
<br />
<br />

## How to use
apk 디버깅을 원할 시 : 0 -> 1 -> 2 -> 3 -> 7
<br />
jar 파일이 필요할 때 : 0 -> 1 -> 8

## Option Introduction
### 0. Set current project
place-apk-here-for-modding 폴더에서 작업할 apk를 선택합니다. 

### 1. Decompile apk
작업할 apk를 디컴파일하여 projects 폴더에 생성합니다.

### 2. Set AndroidManifest Debuggable Options
디컴파일하여 생성된 폴더에서 AndroidManifest.xml를 찾아 Android:debuggable 옵션을 "true"로 변경하여 줍니다.

### 3. Set smali OnCreate Debug Options
OnCreate에 waitForDebugger() 옵션을 붙여줍니다.
smali코드가 수정됩니다.

Input 값으로는 해당 옵션을 추가할 액티비티의 경로를 넣어줍니다.
ex) com.example.myapp.MainActivity

보통은 AndroidManifest.xml 에서 MAIN 으로 설정된 액티비티의 경로를 넣어주면 됩니다.

### 4. Compile apk
위의 작업이 끝나면 해당 옵션을 사용하여 컴파일을 해줍니다.

### 5. Sign apk
실행시키기 위해 test.key로 signing 해줍니다.

### 6. Install apk
현재 연결된 기기가 있다면 해당 기기에 변경된 apk를 설치하여줍니다.

### 7. Compile apk / Sign apk / Install apk
4, 5, 6번의 과정을 한번에 거쳐줍니다.

### 8. Convert dex to jar
place-apk-here-for-modding 폴더에 apk를 두고 압축을 풉니다.
압축을 푼 후 해당 옵션을 실행하면 classes.dex output.jar로 변환하여 생성합니다.

같은 경로에 생성됩니다.

<br />
<br />

## Thanks to 
apkmanager(웃음투자) : [blog](http://blog.naver.com/PostView.nhn?blogId=softdx&logNo=220791587177&categoryNo=27&parentCategoryNo=0&viewDate=&currentPage=1&postListTopCurrentPage=1&from=search&userTopListOpen=true&userTopListCount=10&userTopListManageOpen=false&userTopListCurrentPage=1)
