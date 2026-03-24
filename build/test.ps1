$files = @("main.qml", "Components\LaunchPadControl.qml", "Components\NavigationMapHelperScreen.qml", "Components\NavigationMapScreen.qml", "Components\TopMiddleControl.qml", "Components\LauncherButton.qml")
foreach ($file in $files) {
    $path = "d:\QtProject\my_car\new_pj\$file"
    if (Test-Path $path) {
        $content = Get-Content $path -Raw
        if ($content -notmatch "/// @brief") {
            $header = "// ==========================================" + "
" +
                      "// 文件名称: $file" + "
" +
                      "// 功能描述: 车机UI系统组件" + "
" +
                      "// 包含布局状态、动画效果及交互逻辑" + "
" +
                      "// ==========================================" + "

"
            $newContent = $header + $content
            [System.IO.File]::WriteAllText($path, $newContent, [System.Text.Encoding]::UTF8)
            Write-Host "Commented $file"
        }
    }
}
