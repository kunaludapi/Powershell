Configuration Filedemo
{
    Node 'localhost'
    {
        File CreateFile 
        {
            Ensure = 'Present'
            DestinationPath = 'C:\Test.txt'
            Contents = 'Hello World!'
        }
    }
}