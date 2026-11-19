#pragma semicolon 1
#pragma newdecls required
#include <sourcemod>
#include <cstrike>

public Plugin myinfo = {
    name = "LAN GunGame Respawn",
    author = "Zasig LAN configuration",
    description = "Optional respawns while GunGame is active; respects GunGame shutdown and winner.",
    version = "1.0.0"
};

ConVar enabled;
ConVar respawnDelay;
bool gunGameActive;
bool gameWon;
int respawns;

public void OnPluginStart()
{
    enabled = CreateConVar("sm_lan_gg_respawn", "1", "Respawn players and bots while GunGame is active", FCVAR_NONE, true, 0.0, true, 1.0);
    respawnDelay = CreateConVar("sm_lan_gg_respawn_delay", "2", "Seconds before GunGame respawn", FCVAR_NONE, true, 0.2, true, 30.0);
    HookEvent("player_death", PlayerDeath, EventHookMode_Post);
    HookEvent("player_team", PlayerTeam, EventHookMode_Post);
    RegAdminCmd("sm_lan_gg_status", ReportStatus, ADMFLAG_GENERIC, "Show GunGame respawn state and counters");
}

public void OnMapStart() { gameWon = false; gunGameActive = false; respawns = 0; }
public void GG_OnStartup(bool command) { gunGameActive = true; gameWon = false; }
public void GG_OnShutdown(bool command) { gunGameActive = false; }
public void GG_OnWinner(int client, const char[] weapon, int victim) { gameWon = true; }

bool RespawnActive() { return enabled.BoolValue && gunGameActive && !gameWon; }

public void PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    if (RespawnActive()) CreateTimer(respawnDelay.FloatValue, RespawnPlayer, event.GetInt("userid"), TIMER_FLAG_NO_MAPCHANGE);
}

public void PlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
    if (RespawnActive() && event.GetInt("team") >= 2 && !event.GetBool("disconnect"))
        CreateTimer(respawnDelay.FloatValue, RespawnPlayer, event.GetInt("userid"), TIMER_FLAG_NO_MAPCHANGE);
}

public Action RespawnPlayer(Handle timer, any userid)
{
    int client = GetClientOfUserId(userid);
    if (RespawnActive() && client > 0 && IsClientInGame(client) && GetClientTeam(client) >= 2 && !IsPlayerAlive(client))
    {
        CS_RespawnPlayer(client);
        respawns++;
    }
    return Plugin_Stop;
}

public Action ReportStatus(int client, int args)
{
    int bots, alive;
    for (int i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) && IsFakeClient(i) && GetClientTeam(i) >= 2)
        {
            bots++;
            if (IsPlayerAlive(i)) alive++;
        }
    }
    ReplyToCommand(client, "[LAN GG] active=%d enabled=%d winner=%d bots=%d alive=%d respawns=%d", gunGameActive, enabled.BoolValue, gameWon, bots, alive, respawns);
    return Plugin_Handled;
}

public Action CS_OnTerminateRound(float &delay, CSRoundEndReason &reason)
{
    if (RespawnActive() && (reason == CSRoundEnd_TerroristWin || reason == CSRoundEnd_CTWin || reason == CSRoundEnd_Draw))
        return Plugin_Handled;
    return Plugin_Continue;
}
