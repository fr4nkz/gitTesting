#!/usr/bin/env bash
# Cifrado Cesar
# Fecha: 2017.11.14
# Add testing line
# Line added from origin

_ayuda() {
    cat <<-EOF
Uso: cesar.sh [-C clave] [-d] <archivo>
  -C NUM   Clave del cifrado/descifrado.
  -d       Descifrar.
    
El valor por defecto para la clave es 3.
EOF
} >&2

_cifrado() {
    indice=$((indice + CLAVE))
    
    if [[ "$indice" -ge "$max" ]]; then
        indice=$(( indice - 27 ))
        printf '%s' "${ABECEDARIO[$indice]}"
    else
        printf '%s' "${ABECEDARIO[$indice]}"
    fi
}

_descifrado() {
    indice=$((indice - CLAVE))

    if [[ "$indice" -gt "$min" ]]; then
        indice=$(( indice + 27 ))
        printf '%s' "${ABECEDARIO[$indice]}"
    else
        printf '%s' "${ABECEDARIO[$indice]}"
    fi
}

_main() {
    max=$((27 - CLAVE))
    min=$((27 + CLAVE))
    
    while read -r -N1 letra; do
        letra="${letra,,}"
        # si es una letra del abecedario
        if [[ "$letra" =~ [a-Z] ]]; then
            # itera sobre el array accediendo por su indice
            for indice in "${!ABECEDARIO[@]}"; do
                # compara letra para conocer su indice
                if [[ "$letra" == "${ABECEDARIO[$indice]}" ]]; then
                    if [[ "$ACCION" == 'descifrar' ]]; then
                        _descifrado
                        continue 2
                    else
                        _cifrado
                        continue 2
                    fi
                fi
            done
        elif [[ "$letra" == '' ]]; then
            echo ""
        else
            printf '%s' "$letra"
        fi
    done < "$1"
}


## MAIN ##

ABECEDARIO=(a b c d e f g h i j k l m n ñ o p q r s t u v w x y z)
declare -i CLAVE=3  # Con un valor no entero, toma como valor 0.
NUMARGS="$#"

while getopts ":C:dh" opts; do
    case $opts in
        C)  CLAVE="$OPTARG"
            if [[ "$CLAVE" -eq 0 ]]; then
                echo -e "La opcion -C requiere un valor numerico.\n" >&2
                _ayuda && exit 3
            fi
            ;;
        d)  ACCION='descifrar'
            ;;
        h)  _ayuda
            exit 1
            ;;
        \?) echo -e "La opcion -$OPTARG no es una opcion valida.\n" >&2
            _ayuda
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))

[[ "$NUMARGS" -eq 0 ]] && _ayuda && exit 2
[[ -z "$1" ]] && \
    echo -e "Se necesita un archivo como argumento.\n" >&2 && _ayuda && exit 2
[[ ! -f "$1" ]] && echo "$1 no es un archivo." >&2 && exit 2

_main "$1"        
