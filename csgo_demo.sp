#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

#define VERSION "1.0.0"

char demoName[128];

public Plugin myinfo = {
    name = "goTv demo management",
    author = "marqdevx",
    description = "Start and stop the gotv recording",
    version = VERSION,
    url = "https://github.com/marqdevx/sm-plugins"
}

public void OnPluginStart(){
    RegAdminCmd("sm_startdemo", Command_startdemo, ADMFLAG_GENERIC, "Start demo recording");
    RegAdminCmd("sm_stopdemo", Command_stopdemo, ADMFLAG_GENERIC, "Stop demo recording");
}

public Action welcomeMessage(Handle timer, int client){
    PrintToChat(client, " \x02 [Demo] \x03 Available commands: \x10.record\x03, \x10.stopdemo\x03");
    return Plugin_Handled;
}

public void OnClientConnected(int client){
    if (!CheckCommandAccess(client, "sm_startdemo", ADMFLAG_GENERIC)){ PrintToChat(client, "no access"); return; }
    CreateTimer(8.0, welcomeMessage, client);
}

public Action Command_startdemo(int client, int args)
{
	//char demoName[128];
	char actualTime[32];
	char actualMap[32];

	FormatTime(actualTime, sizeof(actualTime), "%d%B_%H-%M", GetTime());	//https://www.tutorialspoint.com/c_standard_library/c_function_strftime.htm
	GetCurrentMap(actualMap, sizeof(actualMap));

	StrCat(demoName, 256, actualTime);
	StrCat(demoName, 256, "_");
	StrCat(demoName, 256, actualMap[3]);

	PrintToChat(client, "Demo will be saved at gotv/%s.dem", demoName);

	ServerCommand("tv_record gotv/%s", demoName);

	return Plugin_Handled;
}

public Action Command_stopdemo(int client, int args)
{
	PrintToChat(client, "Demo saved at gotv/%s.dem", demoName);

	ServerCommand("tv_stoprecord");

	return Plugin_Handled;
}

// Custom chat commands with dot prefix
public void OnClientSayCommand_Post(int client, const char[] command, const char[] sArgs)
{
	if (!CheckCommandAccess(client, "sm_startdemo", ADMFLAG_GENERIC))
	{
		return;
	}

	if (StrEqual(sArgs, ".stopdemo", false))
	{
		Command_stopdemo(client, 0);
	}
	else if (StrEqual(sArgs, ".record", false))
	{
		Command_startdemo(client, 0);
	}
}
