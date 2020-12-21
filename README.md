# README

Skript pro scrapování počtu podpisů pro vznik hnutí [Lidé PRO](https://lidepro.cz/) a pohybu na [transparentním účtu hnutí](https://ib.fio.cz/ib/transparent?a=20308993).

## Grafy

### Podpisy

![](output/signatures.png)

![](output/signatures_speed.png)

### Transparentní účet

![](output/money.png)

## File manifest

- `src/scrap-signatures-count.R` - skript pro stáhnutí počtu podpisů uvedených na stránce [Lidé PRO](https://lidepro.cz/podpisy)  
- `src/chart-data.R` - skript pro vygenerování grafů výše  
- `output/output.csv` - data s počty podpisů (sloupec time je v časové zóně UTC)  

