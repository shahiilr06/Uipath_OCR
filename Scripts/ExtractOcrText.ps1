param (
    [Parameter(Mandatory=$true)]
    [string]$Path
)

Add-Type -AssemblyName System.Runtime.WindowsRuntime

$null = [Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime]
$null = [Windows.Media.Ocr.OcrEngine, Windows.Foundation, ContentType = WindowsRuntime]
$null = [Windows.Graphics.Imaging.BitmapDecoder, Windows.Graphics.Imaging, ContentType = WindowsRuntime]
$null = [Windows.Storage.Streams.IRandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime]

$ocrEngine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
if ($null -eq $ocrEngine) {
    $lang = New-Object Windows.Globalization.Language("en")
    if ([Windows.Media.Ocr.OcrEngine]::IsLanguageSupported($lang)) {
        $ocrEngine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromLanguage($lang)
    }
}

$getAwaiterMethod = [WindowsRuntimeSystemExtensions].GetMember('GetAwaiter', 'Method', 'Public,Static') | 
    Where-Object { $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' } | 
    Select-Object -First 1

function Invoke-Async {
    param ($AsyncTask, [Type]$ReturnType)
    $genericMethod = $getAwaiterMethod.MakeGenericMethod($ReturnType)
    $awaiter = $genericMethod.Invoke($null, @($AsyncTask))
    return $awaiter.GetResult()
}

$resolvedPath = (Resolve-Path $Path).ProviderPath
$asyncFile = [Windows.Storage.StorageFile]::GetFileFromPathAsync($resolvedPath)
$storageFile = Invoke-Async $asyncFile ([Windows.Storage.StorageFile])

$asyncStream = $storageFile.OpenAsync([Windows.Storage.FileAccessMode]::Read)
$stream = Invoke-Async $asyncStream ([Windows.Storage.Streams.IRandomAccessStream])

$asyncDecoder = [Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)
$decoder = Invoke-Async $asyncDecoder ([Windows.Graphics.Imaging.BitmapDecoder])

$asyncBmp = $decoder.GetSoftwareBitmapAsync()
$softwareBitmap = Invoke-Async $asyncBmp ([Windows.Graphics.Imaging.SoftwareBitmap])

$asyncOcr = $ocrEngine.RecognizeAsync($softwareBitmap)
$ocrResult = Invoke-Async $asyncOcr ([Windows.Media.Ocr.OcrResult])

foreach ($line in $ocrResult.Lines) {
    Write-Output $line.Text
}
