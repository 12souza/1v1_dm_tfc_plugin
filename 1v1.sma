/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <tfcx>

#define PLUGIN "1v1"
#define VERSION "1.0"
#define AUTHOR "msouz"

new killgoal;
new playerReady[32];
new numPlayerReady;
new gameON = 0;
new playerKills[32]

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	killgoal = register_cvar("kill_goal","50")
	register_event( "DeathMsg", "death", "a" )
	register_clcmd("say", "ready");
	register_clcmd("say !test", "test");
	
}

public plugin_precache() 
    { 
    precache_sound("sound/fight.mp3")
    precache_sound("sound/victory.mp3")
    }

public ready(id)
{   
	if(gameON == 0){
	    new buffer[256];
	    new buffer1[33];
	    new buffer2[33];
	    new name[32];
	    get_user_name(id, name, 31);
	    read_argv(1, buffer, 255);
	    parse(buffer, buffer1, 32, buffer2, 32);
	    
		if (equali(buffer1, "!ready", 0))
	    {

			//code for ready up
			if(numPlayerReady == 0){
				playerReady[id] = 1;
				client_print(0, print_chat, "%s is ready", name);
				numPlayerReady++;
			}
			else if(numPlayerReady == 1){
				client_print(0, print_chat, "%s is ready", name);
				client_print(0, print_chat, "***PREPARE TO FIGHT****");
				playerReady[id] = 2;
				slayPlayers();
				client_cmd(0,"mp3 play sound/fight.mp3"); //plays countdown
			}
	    }
	return 0;
}

public slayPlayers(){
	//will kill players that have readied up
	for(new i = 0; i < 32; ++i)
	{
		if(playerReady[i] > 0){
			new name[32]
			get_user_name(i, name, 31);
			//client_print(0, print_chat, "***PREPARE TO FIGHT****");
			server_cmd("amx_slay %s",name);
		}
	}
	set_task(3.0, "turngameON", 0, "", 0, "a", 1); //needs to be a delay for the gameON function so that players dont lose a kill when the server kills them to start.
}

public turngameON(){
	//needs to be a delay for the gameON function so that players dont lose a kill when the server kills them to start.
	gameON = 1;
}

public death() {
	if(gameON){
	    //client_print(0, print_chat, "test");
	    new attacker = read_data(1);
	    new victim = read_data(2);
	    new aname[32], vname[32];
	    get_user_name(attacker, aname, 31);
	    get_user_name(victim, vname, 31);
	       
	    if(attacker == victim){
		playerKills[victim]--;
		client_print(0, print_chat, "%s killed themselves and now has %d kills", vname, playerKills[victim]);
		
	    }
	    else if(attacker != victim){
		playerKills[attacker]++;
	    
		client_print(0, print_chat, "%s %d - %s %d", aname, playerKills[attacker], vname, playerKills[victim]);
	    }
	    
	    if(playerKills[attacker] == get_pcvar_num(killgoal)) {
			client_print(0, print_chat, "%s HAS WON THE MATCH", aname);
			client_cmd(0,"mp3 play sound/victory.mp3");
			gameON = 0;
			playerReady[attacker] = 0
			playerReady[victim] = 0
			playerKills[attacker] = 0
			playerKills[victim] = 0
	    }
	    
	    
	   }
	return PLUGIN_CONTINUE
    
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
