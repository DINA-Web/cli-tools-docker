# generate redlist containing CollectionObjectIDs accessible
# to be used for weeding out items based on their
# CollectionObjectID linkage

create table if not exists redlist
select
	t.TaxonID,
	d.CollectionObjectID
#	t.Fullname
from
	determination d inner join taxon t on d.TaxonID = t.TaxonID
where
	t.FullName in ('Calosoma auropunctatum', 'Calosoma reticulatum', 'Harpalus autumnalis', 'Aesalus scarabaeoides', 'Chalcophora mariana', 'Lacon lepidopterus', 'Lacon querceus', 'Ampedus nigerrimus', 'Reitterelater dubius', 'Ischnodes sanguinicollis', 'Cardiophorus gramineus', 'Prostomis mandibularis', 'Lytta vesicatoria', 'Meloe brevicollis', 'Eledonoprius armatus', 'Cerambyx cerdo', 'Mesosa curculionoides', 'Monochamus urussovii', 'Pseudocleonus grammicus', 'Cyphocleonus trisulcatus', 'Halictus quadricinctus', 'Lasioglossum xanthopus', 'Lasioglossum quadrinotatulum', 'Sphecodes cristatus', 'Sphecodes spinulosus', 'Andrena humilis', 'Andrena chrysopyga', 'Andrena gelriae', 'Andrena bluethgeni', 'Andrena morawitzi', 'Melitta melanura', 'Osmia maritima', 'Coelioxys obtusispina', 'Coelioxys conoidea', 'Nomada similis', 'Nomada integra', 'Anthophora plagiata', 'Melecta luctuosa', 'Lestica alata', 'Hyphoraia aulica', 'Lamprotes c-aureum', 'Parnassius mnemosyne', 'Parnassius mnemosyne argiope', 'Parnassius mnemosyne romani', 'Parnassius mnemosyne nordstromi', 'Parnassius mnemosyne atlanticus', 'Melitaea britomartis', 'Plebejus argyrognomon', 'Plebejus argyrognomon norvegicus', 'Lepidurus apus', 'Astacus astacus', 'Atypus affinis', 'Eresus sandaliatus', 'Gavia stellata', 'Ciconia nigra', 'Anser erythropus', 'Anser fabalis', 'Anser fabalis fabalis', 'Pernis apivorus', 'Pernis apivorus/Buteo buteo', 'Milvus milvus', 'Milvus milvus milvus', 'Milvus milvus x migrans', 'Milvus migrans', 'Milvus migrans migrans', 'Haliaeetus albicilla', 'Circus aeruginosus', 'Circus aeruginosus aeruginosus', 'Circus cyaneus', 'Circus cyaneus cyaneus', 'Circus pygargus', 'Circus macrourus', 'Circus macrourus x cyaneus', 'Circus macrourus/cyaneus', 'Circus macrourus/pygargus', 'Accipiter gentilis', 'Accipiter gentilis gentilis', 'Accipiter nisus', 'Accipiter nisus nisus', 'Buteo lagopus', 'Buteo lagopus lagopus', 'Buteo buteo', 'Buteo buteo buteo', 'Buteo buteo vulpinus', 'Aquila chrysaetos', 'Aquila chrysaetos chrysaetos', 'Aquila clanga', 'Aquila chrysaetos/Haliaeetus albicilla', 'Pandion haliaetus', 'Pandion haliaetus haliaetus', 'Falco peregrinus', 'Falco peregrinus peregrinus', 'Falco rusticolus', 'Falco rusticolus, dark morph', 'Falco columbarius', 'Falco columbarius aesalon', 'Falco subbuteo', 'Falco subbuteo subbuteo', 'Falco vespertinus', 'Falco peregrinus/rusticolus', 'Tetrao urogallus', 'Tetrao urogallus urogallus', 'Gallinago media', 'Limosa lapponica', 'Limosa lapponica lapponica', 'Charadrius alexandrinus', 'Charadrius alexandrinus alexandrinus', 'Tyto alba', 'Tyto alba alba', 'Tyto alba guttata', 'Surnia ulula', 'Surnia ulula ulula', 'Glaucidium passerinum', 'Glaucidium passerinum passerinum', 'Strix nebulosa', 'Strix nebulosa lapponica', 'Strix uralensis', 'Strix uralensis liturata', 'Strix uralensis/nebulosa', 'Asio flammeus', 'Asio flammeus flammeus', 'Aegolius funereus', 'Aegolius funereus funereus', 'Bubo bubo', 'Bubo bubo bubo', 'Bubo scandiacus', 'Upupa epops', 'Upupa epops epops', 'Coracias garrulus', 'Coracias garrulus garrulus', 'Alcedo atthis', 'Alcedo atthis atthis', 'Merops apiaster', 'Dendrocopos leucotos', 'Dendrocopos leucotos leucotos', 'Dendrocopos leucotos x major', 'Myotis bechsteinii', 'Pipistrellus pipistrellus', 'Barbastella barbastellus', 'Lynx lynx', 'Canis lupus', 'Canis lupus lupus', 'Alopex lagopus', 'Ursus arctos', 'Gulo gulo', 'Bactrospora brodoi', 'Trapeliopsis viridescens', 'Pilophorus strumaticus', 'Bryoria smithii', 'Cetrelia olivetorum', 'Evernia illyrica', 'Menegazzia subsimilis', 'Stereocaulon delisei', 'Stereocaulon incrustatum', 'Collema fasciculare', 'Erioderma pedicellatum', 'Fuscopannaria sampaiana', 'Sticta fuliginosa ', 'Sticta limbata', 'Sticta sylvatica', 'Calicium lenticulare', 'Tuber aestivum', 'Tuber mesentericum', 'Geastrum campestre', 'Radiigera', 'Radiigera flexuosa', 'Didymodon glaucus', 'Pyramidula tetragona', 'Orthotrichum rogeri', 'Orthotrichum scanicum', 'Orthotrichum tenellum', 'Seligeria carniolica', 'Cryphaea heteromalla', 'Cephalozia macounii', 'Frullania bolanderi', 'Frullania oakesiana', 'Asplenium adiantum-nigrum', 'Asplenium adulterinum', 'Asplenium adulterinum × trichomanes subsp. quadrivalens', 'Asplenium adulterinum × viride', 'Asplenium adulterinum × trichomanes subsp. trichomanes', 'Asplenium ceterach', 'Asplenium scolopendrium', 'Polystichum aculeatum × braunii', 'Polystichum braunii', 'Botrychium simplex', 'Botrychium simplex var. simplex', 'Botrychium simplex var. tenebrosum', 'Allium lineare', 'Herminium monorchis', 'Anacamptis pyramidalis', 'Anacamptis palustris', 'Cephalanthera damasonium', 'Cephalanthera damasonium × longifolia', 'Cephalanthera rubra', 'Cephalanthera longifolia × rubra', 'Dactylorhiza incarnata var. incarnata × majalis subsp. majalis', 'Dactylorhiza incarnata var. ochroleuca × majalis subsp. majalis', 'Dactylorhiza maculata subsp. fuchsii × Gymnadenia odoratissima', 'Dactylorhiza maculata subsp. maculata × majalis subsp. majalis', 'Dactylorhiza majalis', 'Dactylorhiza majalis subsp. majalis', 'Dactylorhiza maculata subsp. fuchsii × majalis subsp. majalis', 'Dactylorhiza majalis subsp. baltica', 'Dactylorhiza majalis subsp. integrata', 'Epipactis phyllanthes', 'Epipactis atrorubens × phyllanthes', 'Epipactis helleborine × phyllanthes', 'Epipogium', 'Epipogium aphyllum', 'Gymnadenia odoratissima', 'Gymnadenia conopsea × odoratissima', 'Gymnadenia runei', 'Gymnadenia nigra', 'Gymnadenia conopsea × Pseudorchis albida', 'Orchis spitzelii', 'Orchis mascula × spitzelii', 'Platanthera obtusata', 'Platanthera obtusata subsp. oligantha', 'Pseudorchis albida', 'Spiranthes spiralis', 'Liparis', 'Liparis loeselii', 'Cypripedium', 'Cypripedium calceolus', 'Malaxis monophyllos', 'Calypso', 'Calypso bulbosa', 'Bromus pseudosecalinus', 'Koeleria grandis', 'Chenopodium vulvaria', 'Ranunculus ophioglossifolius', 'Chrysosplenium oppositifolium', 'Lathyrus sphaericus', 'Viola alba', 'Viola alba × hirta', 'Viola alba × odorata', 'Trapa natans', 'Orobanche elatior', 'Orobanche minor', 'Orobanche picridis', 'Orobanche purpurea', 'Orobanche reticulata', 'Silaum silaus', 'Artemisia stelleriana', 'Taraxacum polium', 'Taraxacum excellens', 'Taraxacum austrinum', 'Taraxacum obtusilobum');


# empty tables with info about loans and shipments
delete from loanattachment;
delete from loanagent;
delete from shipment;
delete from loanreturnpreparation;
delete from loanpreparation;
delete from loan;

# empty items from tables that refer to redlisted stuff

delete from preparation where preparation.CollectionObjectID in 
(select CollectionObjectID from redlist); # 247 rows

delete from determination where determination.CollectionObjectID in
(select CollectionObjectID from redlist); # 107 rows

delete from collectionobjectattachment where
collectionobjectattachment.CollectionObjectID in 
(select CollectionObjectID from redlist); # 58 rows

delete from dnasequence where dnasequence.CollectionObjectID in 
(select CollectionObjectID from redlist); # 155 rows

delete from collectionobject where collectionobject.CollectionObjectID in 
(select CollectionObjectID from redlist); # 106 rows

delete from commonnametx where commonnametx.TaxonID in (select TaxonID
from redlist);

drop table redlist;

# replace Remarks that may carry personal information
update accession set Remarks = ''; # 15 rows
update accessionagent set Remarks = ''; # 39 rows
update collectionobject set Remarks = ''; # 510 911 rows

# replace information about specific storage locations
update preparation set StorageID = 1; # 440 644 rows
update preparation set StorageLocation = ''; # 438 018 rows
update storage set Abbrev = '', FullName = 'DINA', FullName = 'DINA',
Name = '', Remarks = '', Text1 = '', Text2 = '';

# replace attachment info that may carry personal information
update attachment set origFilename = ''; # 17550 rows

# delete information about gifts
delete from giftpreparation;
delete from giftagent;
delete from gift;
delete from recordsetitem;
delete from recordset;
delete from inforequest;

# take this out says Kevin
delete from permitattachment;
delete from accessionauthorization;
delete from permit;
delete from treatmentevent;

# empty the workbench tables
# huge table, dont delete, drop directly instead
create table new_workbenchdataitem like workbenchdataitem;
rename table workbenchdataitem to old_workbenchdataitem, new_workbenchdataitem to workbenchdataitem;
drop table old_workbenchdataitem;

delete from workbenchrowimage;
delete from workbenchrowexportedrelationship;
delete from workbenchtemplatemappingitem;
delete from workbenchrow;
delete from workbench;
delete from workbenchtemplate;

# huge table, dont delete, drop directly instead
create table new_workbenchrow like workbenchrow;
rename table workbenchrow to old_workbenchrow, new_workbenchrow to workbenchrow;
set foreign_key_checks=0;
drop table old_workbenchrow;
set foreign_key_checks=1;

# delete this says Kevin
delete from spappresourcedata;
delete from spreport;
delete from spappresource;

# this is a huge one too
delete from spauditlogfield;
create table new_spauditlog like spauditlog;
rename table spauditlog to old_spauditlog, new_spauditlog to spauditlog;
set foreign_key_checks=0;
drop table old_spauditlog;
set foreign_key_checks=1;

# can probably leave it in there says Ida
# delete from spquery;

#SELECT *
#FROM information_schema.KEY_COLUMN_USAGE
#WHERE REFERENCED_TABLE_NAME = 'old_workbenchrow';

# replace, may contain personal info
update spquery set Name = 'DINA';
