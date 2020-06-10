# IO

Instrukcja do implementacji części systemu

1. Należy pobrać i zainstalować program MySQL Workbench oraz wczytać do bazy plik "io_measurements.sql". Jako host ustawić "localhost:3306", login"root", a hasło "admin".
2. Neleży uruchomić program napisany w języku Java znajdujący się w folderze "IO/src" (program tworzony w środowisku IntelliJ) i zostawić go, aby działał w tle
3. Należy uruchomić skrypt w programie MATLAB, który znajduje się w folderze "MATLAB"
4. Jeżeli wystąpi jakikolwiek błąd związany z dostępem do bazy danych z jednego lub drugiego programu należy dodać connector zgodnie z instrukcjami zawartymi poniżej:

Java: Należy pobrać oraz zaimplementować JDBC connector, tak jak w filmiku: https://www.youtube.com/watch?v=2i4t-SL1VsU

MATLAB: Należy pobrać oraz zaimplementować ODBC connector, tak jak w filmiku: https://www.youtube.com/watch?v=XIgZlCdb-PA

Opis programu:

Z programu należy korzystać wyłącznie poprzez GUI w programie MATLAB. Pozwala ono na śledzenie danych pobieranych od pracowników, przełączanie się pomiędzy pracownikami, a jeśli średnia z ostatnich 10 pomiarów przekracza normę, zostanie wyświetlony komunikat o zagrożeniu pracownika, a także opcje: przejścia do tego pracownika, zignorowania wiadomości oraz rozpoczęcia ewakuacji (przycisk dodany tylko w celach wizualnych - nic nie robi)

