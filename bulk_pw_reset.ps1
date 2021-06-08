Import-Module ActiveDirectory
$users = Get-Content ###DOSYA YOLU###
    $Output = foreach ($user in $users) {
        $kAdi = Get-ADUser -Identity $user -Properties sAMAccountName | Select -ExpandProperty sAMAccountName
        $name = Get-ADUser -Identity $user -Properties Name | Select -ExpandProperty Name
        $pw = Get-ADUser -Identity $user -Properties idNo | Select -ExpandProperty idNo
        $parola = "par0l4" + $pw.Substring($pw.Length -4, 4)
        $password = ConvertTo-SecureString $parola -AsPlainText -Force
Set-ADAccountPassword -Identity $user -NewPassword $password
Set-ADUser -Identity $user -ChangePasswordAtLogon $false
        New-Object -TypeName PSObject -Property @{
        kullaniciAdi = $kAdi
        parola = $parola
        tckimlikNo = $pw
        isimSoyisim = $name
    } | Select-Object isimSoyisim, kullaniciAdi, tckimlikNo, parola
}
$Output | Export-Csv ###CIKTI DOSYASI###
