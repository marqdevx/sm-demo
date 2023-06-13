#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

#define VERSION "1.0.0"

public Plugin myinfo = {
    name = "Medic round backup (restore)",
    author = "marqdevx",
    description = "",
    version = VERSION,
    url = "https://github.com/marqdevx/sm-plugins"
}

public void OnPluginStart(){
    RegAdminCmd("sm_startdemo", Command_startdemo, ADMFLAG_GENERIC, "Start demo recording");
    RegAdminCmd("sm_cfgstopdemo", Command_stopdemo, ADMFLAG_GENERIC, "Stops demo recording");
}

public Action Command_startdemo(int client, int args)
{
	char demoName[128];
	char actualTime[32];
	char actualMap[32];

	FormatTime(actualTime, sizeof(actualTime), "%d%B_%H-%M", GetTime());	//https://www.tutorialspoint.com/c_standard_library/c_function_strftime.htm
	GetCurrentMap(actualMap, sizeof(actualMap));

	StrCat(demoName, 256, actualTime);
	StrCat(demoName, 256, "_");
	StrCat(demoName, 256, actualMap[3]);
	// demoName = ("%s_%s" , actualTime, actualMap);

	PrintToChat(client, "Demo will be saved at gotv/%s.dem", demoName);

	ServerCommand("tv_record gotv/%s", demoName);

	return Plugin_Handled;
}

public Action Command_stopdemo(int client, int args)
{
	PrintToChatAll("Stopping recording");
	ServerCommand("tv_stoprecord");

	return Plugin_Handled;
}

// Custom chat commands with dot prefix
public void OnClientSayCommand_Post(int client, const char[] command, const char[] sArgs)
{
	if (!CheckCommandAccess(client, "sm_cfgstopdemo", ADMFLAG_GENERIC))
	{
		return;
	}

	else if (StrEqual(sArgs, ".stopdemo", false))
	{
		Command_stopdemo(client, 0);
	}
	else if (StrEqual(sArgs, ".record", false))
	{
		Command_startdemo(client, 0);
	}
}
