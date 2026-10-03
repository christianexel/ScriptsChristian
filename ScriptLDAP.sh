#!/bin/bash
BASE="dc=christian2026,dc=ldap"
ADMIN="cn=admin,$BASE"

echo "MENU LDAP"
echo "1. Eliminar correo"
echo "2. Modificar correo"
echo "3. Busquedas"
read -p "Opcion: " opcion

case $opcion in
  1)
    read -p "Usuario: " u
    read -p "Grupo: " g
    read -p "OU: " ou
    echo -e "dn: uid=$u,cn=$g,ou=$ou,$BASE\nchangetype: modify\ndelete: mail" | ldapmodify -x -D "$ADMIN" -W
    ;;
  2)
    read -p "Usuario: " u
    read -p "Grupo: " g
    read -p "OU: " ou
    read -p "Nuevo correo: " m
    echo -e "dn: uid=$u,cn=$g,ou=$ou,$BASE\nchangetype: modify\nreplace: mail\nmail: $m" | ldapmodify -x -D "$ADMIN" -W
    ;;
  3)
    echo "1. Consultar un usuario"
    echo "2. Listar todos"
    read -p "Subopcion: " sub
    if [ "$sub" = "1" ]; then
      read -p "UID del usuario: " u
      ldapsearch -x -LLL -b "$BASE" "(uid=$u)" cn mail
    else
      if [ "$sub" = "2" ]; then
        ldapsearch -x -LLL -b "$BASE" "(objectClass=inetOrgPerson)" cn mail | grep -E "^cn:|^mail:"
      else
        echo "Subopcion no valida."
      fi
    fi
    ;;
  *)
    echo "Opcion no valida."
    ;;
esac
