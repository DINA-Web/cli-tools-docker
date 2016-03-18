DB="dina_nrm"
(
    echo 'ALTER DATABASE `'"$DB"'` CHARACTER SET utf8 COLLATE utf8_general_ci;'
    mysql -h 127.0.0.1 -u root -ppassword12 -D "$DB" -e "SHOW TABLES" --batch --skip-column-names \
    | xargs -I{} echo 'ALTER TABLE `'{}'` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;'
) \
| mysql -h 127.0.0.1 -u root -ppassword12 -D "$DB"

mysql -h 127.0.0.1 -u root -ppassword12 -D "$DB" -e "show variables like 'character_set_%';"
