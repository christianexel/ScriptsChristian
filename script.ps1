Import-Module ActiveDirectory

# El menu se repite hasta elegir Salir
$opcion = ""

while ($opcion -ne "5") {

# Mostramos el menu
Write-Host "MENU"
Write-Host "1. Mostrar informacion del dominio"
Write-Host "2. Crear una nueva Unidad Organizativa"
Write-Host "3. Crear un nuevo grupo"
Write-Host "4. Crear una nueva cuenta de usuario"
Write-Host "5. Salir"

$opcion = Read-Host "Elige una opcion"

switch ($opcion) {

    # Opcion 1: informacion del dominio
    "1" {
        Write-Host "Nombre del equipo: $env:COMPUTERNAME"
        Write-Host "Nombre del dominio: $((Get-ADDomain).DNSRoot)"
        Write-Host "Numero de OUs: $((Get-ADOrganizationalUnit -Filter *).Count)"
        Write-Host "Numero de grupos: $((Get-ADGroup -Filter *).Count)"
        Write-Host "Numero de usuarios: $((Get-ADUser -Filter *).Count)"
    }

    # Opcion 2: crear una Unidad Organizativa
    "2" {
        $nombreOU = Read-Host "Nombre de la nueva Unidad Organizativa"
        New-ADOrganizationalUnit -Name $nombreOU -Path (Get-ADDomain).DistinguishedName
        Write-Host "Unidad Organizativa $nombreOU creada"
    }

    # Opcion 3: crear un grupo
    "3" {
        $nombreGrupo = Read-Host "Nombre del nuevo grupo"
        New-ADGroup -Name $nombreGrupo -GroupScope Global
        Write-Host "Grupo $nombreGrupo creado"
    }

    # Opcion 4: crear un usuario
    "4" {
        $nombre = Read-Host "Nombre"
        $usuario = Read-Host "Nombre de usuario"
        $contrasena = Read-Host "Contrasena" -AsSecureString
        $grupo = Read-Host "Grupo al que pertenecera"

        # ChangePasswordAtLogon obliga a cambiar la contrasena en el primer inicio de sesion
        New-ADUser -Name $nombre -SamAccountName $usuario -AccountPassword $contrasena -Enabled $true -ChangePasswordAtLogon $true
        Add-ADGroupMember -Identity $grupo -Members $usuario
        Write-Host "Usuario $usuario creado y anadido al grupo $grupo"
    }

    # Opcion 5: salir
    "5" {
        Write-Host "Saliendo..."
    }

    # Cualquier otra cosa
    default {
        Write-Host "Opcion no valida"
    }
}

}
