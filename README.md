Repozytorium na rzecz zajęć z Technologii NoSQL (zadania egzaminacyjne)
=========

### Sprzęt
Rodzaj  | CPU | RAM | System
------- | --- | --- | ----
Laptop  | Core i5-2430M 2x2.4GHz  | 8GB DDR3 | Windows 7
=========

####Zadanie 1

Przygotować funkcje map i reduce, które:
- wyszukają wszystkie anagramy w pliku [word_list.txt](http://wbzyl.inf.ug.edu.pl/nosql/doc/data/word_list.txt)


**Rozwiązanie:**

Import pliku do bazy

```sh
mongoimport -c wordlist --file word_list.txt -f "word"
```

Czasy
```sh
real    0m0.823s
user    0m0.000s
sys     0m0.047s
```

MapReduce

```js
var map = function() {
	var prepared = this.word.split("").sort().join("");
	emit(prepared, this.word);
};

var reduce = function(key, values) {
	agramy = {
		"anagramy": values,
		"ilosc_anagramow": values.length
	};
	return agramy
};

db.words.mapReduce(map, reduce, {
	out: "anagramy"
})
```

Przykładowe wyniki

```json
{
	"_id": "aaclrs",
	"value": {
		"anagramy": ["rascal", "scalar"],
		"ilosc": 2
	}
} 
{
	"_id": "aaclsu",
	"value": {
		"anagramy": ["casual", "causal"],
		"ilosc": 2
	}
}
{
	"_id": "aailmn",
	"value": {
		"anagramy": ["animal", "lamina", "manila"],
		"
		ilosc " : 3 } } {
		"_id": "aailrt",
		"value": {
			"anagramy": ["atrial", "lariat"],
			"ilosc": 2
		}
	}

{
		"_id": "aailsv",
		"value": {
			"anagramy": ["avails", "saliva"],
			"ilosc": 2
		}
	} 
	{
		"_id": "aaimnr",
		"value": {
			"anagramy": ["airman", "marina"],
			"ilosc": 2
		}
	} 
	{
		"_id": "aainpt",
		"value": {
			"anagramy": ["patina", "pinata"],
			"ilosc": 2
		}
	}
```


####Zadanie 2

Przygotować funkcje map i reduce, które:
 - wyszukają najczęściej występujące słowa z [Wikipedia data PL](http://dumps.wikimedia.org/plwiki/) aktualny plik z artykułami, ok. 1.3 GB


 **Rozwiązanie:**

 Import do bazy
	Aby zaimportować plik użyłem [skryptu PHP](/convert.php)

	Czasy
	```sh
real    83m45.963s
user    0m0.000s
sys     0m0.046s

	```

MapReduce (Najczęściej występujące słowa w tytułach artykułów) - około 25minut

```js
var map = function() {
  var tmp = this.title.match(/[a-ząśżźęćńół]+/gi);
  if (tmp) {
    for (var i = 0; i < tmp.length; i++)
      emit(tmp[i], 1)
  }
};



var reduce = function(key, values) {
  var total = 0;
  for (var i = 0; i < values.length; i++) {
    total += values[i];
  }
  return total;
};


db.page.mapReduce(map, reduce, {
  out: 'myoutput'
});
```

Wynik (10 najczęstszych słów w artykułach)

```json
{
	"_id": "Kategoria",
	"value": 140494
} {
	"_id": "w",
	"value": 118729
} {
	"_id": "Szablon",
	"value": 49402
} {
	"_id": "Wikipedia",
	"value": 41634
} {
	"_id": "na",
	"value": 35152
} {
	"_id": "powiat",
	"value": 21085
} {
	"_id": "województwo",
	"value": 18952
} {
	"_id": "i",
	"value": 18419
} {
	"_id": "Gmina",
	"value": 15672
} {
	"_id": "Poczekalnia",
	"value": 14943
}
```

Wynik (10 najczęstszych słów w tekstach artykułów) - ok 13godzin

MapReduce
```js
var map = function() {
  var temp = this.revision.text.match(/[a-ząśżźęćńół]+/gi);
  if (temp) {
    for (var i = 0; i < temp.length; i++)
      emit(temp[i], 1)
  }
};



var reduce = function(key, values) {
  var total = 0;
  for (var i = 0; i < values.length; i++) {
    total += values[i];
  }
  return total;
};
```

Wynik:
```json
{ "_id" : "w", "value" : 13324479 }
{ "_id" : "i", "value" : 5701710 }
{ "_id" : "align", "value" : 4910641 }
{ "_id" : "na", "value" : 4495496 }
{ "_id" : "z", "value" : 4420915 }
{ "_id" : "ref", "value" : 4264256 }
{ "_id" : "data", "value" : 3495165 }
{ "_id" : "Kategoria", "value" : 3169267 }
{ "_id" : "do", "value" : 2824854 }
{ "_id" : "center", "value" : 2719355 }
{ "_id" : "się", "value" : 2572812 }
{ "_id" : "http", "value" : 2324495 }
{ "_id" : "br", "value" : 2221883 }
{ "_id" : "W", "value" : 2092043 }
{ "_id" : "www", "value" : 2053473 }
{ "_id" : "left", "value" : 2038389 }
{ "_id" : "tytuł", "value" : 1668414 }
{ "_id" : "a", "value" : 1552049 }
{ "_id" : "roku", "value" : 1512300 }
{ "_id" : "small", "value" : 1466686 }
{ "_id" : "style", "value" : 1432669 }
{ "_id" : "bgcolor", "value" : 1400559 }
{ "_id" : "flaga", "value" : 1370427 }
{ "_id" : "r", "value" : 1360426 }
{ "_id" : "px", "value" : 1339676 }
{ "_id" : "nie", "value" : 1292801 }
{ "_id" : "RD", "value" : 1275589 }
{ "_id" : "jest", "value" : 1260451 }
{ "_id" : "pl", "value" : 1236434 }
{ "_id" : "o", "value" : 1161591 }
{ "_id" : "name", "value" : 1098244 }
{ "_id" : "język", "value" : 1059961 }
{ "_id" : "nazwa", "value" : 1057043 }
{ "_id" : "to", "value" : 1023694 }
{ "_id" : "Plik", "value" : 1023595 }
{ "_id" : "przez", "value" : 1011081 }
{ "_id" : "url", "value" : 1005559 }
{ "_id" : "infobox", "value" : 995651 }
{ "_id" : "span", "value" : 991491 }
{ "_id" : "com", "value" : 985202 }
{ "_id" : "od", "value" : 970581 }
{ "_id" : "of", "value" : 960208 }
{ "_id" : "miejsce", "value" : 958990 }
{ "_id" : "stronę", "value" : 952673 }
{ "_id" : "rok", "value" : 920231 }
{ "_id" : "dostępu", "value" : 908851 }
{ "_id" : "cytuj", "value" : 894212 }
{ "_id" : "width", "value" : 867188 }
{ "_id" : "Flaga", "value" : 860881 }
{ "_id" : "gmina", "value" : 836968 }
{ "_id" : "en", "value" : 817481 }
{ "_id" : "commons", "value" : 808998 }
{ "_id" : "right", "value" : 794141 }
{ "_id" : "m", "value" : 780295 }
{ "_id" : "class", "value" : 778226 }
{ "_id" : "A", "value" : 763697 }
{ "_id" : "opis", "value" : 743956 }
{ "_id" : "oraz", "value" : 739158 }
{ "_id" : "s", "value" : 738951 }
{ "_id" : "score", "value" : 738330 }
{ "_id" : "jako", "value" : 722699 }
{ "_id" : "Wikipedysta", "value" : 717783 }
{ "_id" : "de", "value" : 710963 }
{ "_id" : "jpg", "value" : 710534 }
{ "_id" : "opublikowany", "value" : 709211 }
{ "_id" : "nbsp", "value" : 702217 }
{ "_id" : "po", "value" : 700615 }
{ "_id" : "ur", "value" : 671065 }
{ "_id" : "svg", "value" : 667047 }
{ "_id" : "imię", "value" : 651842 }
{ "_id" : "nazwisko", "value" : 643759 }
{ "_id" : "B", "value" : 642295 }
{ "_id" : "Dyskusja", "value" : 641975 }
{ "_id" : "I", "value" : 639920 }
{ "_id" : "div", "value" : 618713 }
{ "_id" : "że", "value" : 607602 }
{ "_id" : "II", "value" : 579073 }
{ "_id" : "F", "value" : 569621 }
{ "_id" : "autor", "value" : 547932 }
{ "_id" : "C", "value" : 547360 }
{ "_id" : "zdjęcie", "value" : 542350 }
{ "_id" : "za", "value" : 523029 }
{ "_id" : "color", "value" : 516746 }
{ "_id" : "html", "value" : 515977 }
{ "_id" : "u", "value" : 510517 }
{ "_id" : "został", "value" : 507792 }
{ "_id" : "text", "value" : 504266 }
{ "_id" : "bioindex", "value" : 495193 }
{ "_id" : "państwo", "value" : 492384 }
{ "_id" : "dla", "value" : 490448 }
{ "_id" : "in", "value" : 486717 }
{ "_id" : "background", "value" : 485036 }
{ "_id" : "x", "value" : 479647 }
{ "_id" : "powiat", "value" : 474098 }
{ "_id" : "województwo", "value" : 472958 }
{ "_id" : "Mistrzostwa", "value" : 468839 }
{ "_id" : "d", "value" : 468556 }
{ "_id" : "font", "value" : 466343 }
{ "_id" : "f", "value" : 465542 }
{ "_id" : "The", "value" : 464595 }
```


####Poza zadaniami wykonałem kilka MapReduce na różnych bazach, 
które pozostały mi z wcześniejszych zadań

MapReduce wykonane na bazie [lotnisk](http://ourairports.com/data/)
Liczba typów lotnisk na świecie
```js
var map = function() {
	emit(this.type, 1);
};

var reduce = function(key, val) {
	var count = 0;
	for (i = 0; i < val.length; i++) {
		count += val[i];
	}
	return count;
};

db.lostniska.mapReduce(map, reduce, {
	out: 'result'
});


```

Wynik
```json
{
	"_id": {
		"typ": "small_airport"
	},
	"value": {
		"count": 29734
	}
} {
	"_id": {
		"typ": "heliport"
	},
	"value": {
		"count": 8968
	}
} {
	"_id": {
		"typ": "medium_airport"
	},
	"value": {
		"count": 4526
	}
} {
	"_id": {
		"typ": "closed"
	},
	"value": {
		"count": 1354
	}
} {
	"_id": {
		"typ": "seaplane_base"
	},
	"value": {
		"count": 905
	}
} {
	"_id": {
		"typ": "large_airport"
	},
	"value": {
		"count": 569
	}
} {
	"_id": {
		"typ": "balloonport"
	},
	"value": {
		"count": 17
	}
}
```


MapReduce wykonane na bazie [Lotów](http://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time)

Z jakich stanów ameryki latano najczęściej
MapReduce 
```js
var map = function() {
	emit(this.ORIGIN_STATE_NM, 1);
}

var reduce = function(key, values) {
	var total = 0;
	for (var i = 0; i < values.length; i++) {
		total += values[i];
	}
	return total;
};
```

Wynik 
```json
{ "_id" : "California", "value" : 60804 }
{ "_id" : "Texas", "value" : 59834 }
{ "_id" : "Florida", "value" : 37895 }
{ "_id" : "Georgia", "value" : 31941 }
{ "_id" : "Illinois", "value" : 29270 }
{ "_id" : "New York", "value" : 20817 }
{ "_id" : "Colorado", "value" : 20655 }
{ "_id" : "Arizona", "value" : 15186 }
{ "_id" : "North Carolina", "value" : 14421 }
{ "_id" : "Virginia", "value" : 13107 }
```
