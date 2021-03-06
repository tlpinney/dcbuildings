all: BldgPly/buildings.shp AddressPt/addresses.shp TractPly/tracts.shp directories chunks osm

clean:
	rm -f BldgPly.zip
	rm -f AddressPt.zip
	rm -f TractPly.zip

BldgPly.zip:
	curl -L "http://dcatlas.dcgis.dc.gov/catalog/download.asp?downloadID=1021&downloadTYPE=ESRI" -o BldgPly.zip

AddressPt.zip:
	curl -L "http://dcatlas.dcgis.dc.gov/catalog/download.asp?downloadID=2182&downloadTYPE=ESRI" -o AddressPt.zip

TractPly.zip:
	curl -L "http://dcatlas.dcgis.dc.gov/catalog/download.asp?downloadID=45&downloadTYPE=ESRI" -o TractPly.zip

BldgPly: BldgPly.zip
	unzip BldgPly.zip -d BldgPly

AddressPt: AddressPt.zip
	unzip AddressPt.zip -d AddressPt

TractPly: TractPly.zip
	unzip TractPly.zip -d TractPly

BldgPly/buildings.shp: BldgPly
	rm -f BldgPly/buildings.*
	ogr2ogr -simplify 0.2 -t_srs EPSG:4326 -overwrite BldgPly/buildings.shp BldgPly/BldgPly.shp

AddressPt/addresses.shp: AddressPt
	rm -f AddressPt/addresses.*
	ogr2ogr -t_srs EPSG:4326 -overwrite AddressPt/addresses.shp AddressPt/AddressPt.shp

TractPly/tracts.shp: TractPly
	rm -f TractPly/tracts.*
	ogr2ogr -t_srs EPSG:4326 TractPly/tracts.shp TractPly/TractPly.shp

chunks: directories
	python chunk.py AddressPt/addresses.shp TractPly/tracts.shp chunks/addresses-%s.shp TRACT
	python chunk.py BldgPly/buildings.shp TractPly/tracts.shp chunks/buildings-%s.shp TRACT

osm: directories
	python convert.py

directories:
	mkdir -p chunks
	mkdir -p osm
