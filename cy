#!/bin/bash

cd progc
chmod 700 programme_s.c
chmod 700 programme_t.c
cd ..

# Argument
if [ $# -eq 0 ]; then
    echo -e "Aucun argument \n"
    exit 1
fi

if [ $# -eq 1 ]; then
    echo -e "Choisissez un traitement \n"
    exit 1
fi

#traitement d1
elif [ "$arg" == "-d1" ] || [ "$arg" == "-D1" ]; then
awk -F';' '$2 == 1 {conducteurs[$6]++} END {for (conducteur in conducteurs) print conducteurs[conducteur], conducteur}' "$fichier_csv" | sort -k1,1nr | head -n 10 | awk -F' ' '{print $2 " " $3 ";" $1}' > temp/top10_conducteur.txt 

awk '{a[i++]=$0} END {for (j=i-1; j>=0;) print a[j--] }' temp/top10_conducteur.txt > temp/top10_temp.txt 

cat temp/top10_temp.txt > temp/data_d1.txt

#traitement d2
elif [ "$arg" == "-d2" ] || [ "$arg" == "-D2" ]; then
cat data.csv | cut -d";" -f5,6 | awk -F ';' '{noms[$1] += $2; sommes[$1] = $2} END {for (k in noms) print k ";" noms[k] ";" sommes[k]}' | sort -rn | head -10 > temp/result_D2.txt
gnuplot -persist << GNU_CMD
set terminal png
set output "histogramme_D2.png"
set style fill solid
set boxwidth 2
set ylabel "option -d2"
set xlabel "Noms Conducteurs"
set y2label "Nombre Trajets"
set xtics rotate by 90 right
plot "temp/result_D2.txt" using 1:xtic(2) with histograms title "Nombre de Trajets"
GNU_CMD
  #traitement l 

elif [ "$arg" == "-l" ] || [ "$arg" == "-L" ]; then

    start_time=$(date +%s)
    awk -F ';' '{
        trajet = $1;  # Colonne du trajet
        distance = $5;  # Colonne de la distance

        if (trajet != "" && distance != "") {
            sum[trajet] += distance;
        }
    }
    END {
        for (trajet in sum) {
            printf "%s;%d\n", trajet, sum[trajet];
        }
    }' data/data.csv | sort -t';' -k2,2nr | head -n 10 | sort -t';' -k1,1nr > temp/templ.txt
    cat temp/templ.txt
    end_time=$(date +%s)
    elapsed_time=$(echo "$end_time - $start_time" | bc)
    echo "Temps écoulé : $elapsed_time secondes"
