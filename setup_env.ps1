# Получаем IPv4 адрес адаптера, который смотрит в сеть (исключая localhost и docker)
$ip = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { 
    $_.InterfaceAlias -notlike "*Loopback*" -and 
    $_.InterfaceAlias -notlike "*vEthernet*" -and 
    $_.IPAddress -notlike "169.254*" 
} | Select-Object -ExpandProperty IPAddress -First 1

if (-not $ip) {
    Write-Error "Не удалось определить IP. Впиши его в .env вручную."
    exit
}

echo "Detected External IP: $ip"

# Записываем в файл .env
echo "PUBLIC_IP=$ip" > .env

echo "Файл .env создан успешно!"
Get-Content .env