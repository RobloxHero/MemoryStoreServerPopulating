<div align="center">
<h3>This plugin is still in Development</h3>
<br>
<a href="https://www.roblox.com/library/14113075182/Memory-Store-Server-Populating">
<img width=125 src="https://storage.googleapis.com/compass-of-truth/images/ToolbarOpenWidget.jpg"/>
<h3 >Memory Store Server Population Plugin</h3>
</a>
</div>
<div align="center">
<a href="https://www.roblox.com/library/14113075182/Memory-Store-Server-Populating">
<h3>Dev Forum Link<h3>
</a>
<br>
</div>

This is a Server Matchmaking plugin that uses Memory Store.

**Game Servers** add and remove themselves from the Memory Store as they spin up and shutdown.

**Lobby Servers** teleport people to the available servers.

<br>

<h2>Install</h2>

1. After installing the plugin, select the server type. (Game or Lobby Server)

2. Select the Version you would like to install. (Github Version)

3. Click update. When update is clicked the latest code is pulled from Github.
<h3>Lobby Server</h3>

<p> In s ServerScriptService script require the module.</p>

```lua
local MSSP = require(script.Parent["MSSP-Lobby-Module"])
 ```

<p> Then, in your onPlayerAdded function, load the server admin gui for your admins.</p>

```lua
local ServerAdminGui = MSSP.LoadGui(player)
 ```

<p> In an Event, add the player to a server.</p>

```lua
MSSP.TeleportToFirstAvailableServer(player, PlaceId)
 ```

<h3>Game Server</h3>

<p> In s ServerScriptService script require the module.</p>

```lua
local MSSP = require(script.Parent["MSSP-Game-Module"])
 ```

<p> Configure the Module</p>

```lua
MSSP.Configure(ServerName, ServerMaxPlayers, PlaceId)
 ```

<p> Then, in your onPlayerAdded function add the player to the server.</p>

```lua
MSSP.AddPlayerToServer(player, #Players:GetChildren())
 ```

<p> Then in your onPlayerRemoved function remove the player from the server</p>

```lua
MSSP.RemovePlayerFromServer(player)
 ```

<br>

<h3>Development Milestones:</h3>

1. Server Admin Gui on Lobby Servers &#10003;

2. Game Server Module Creation &#10003;

3. Populating logic for Game Servers

4. Testing / Bug Fixes

5. Documentation

<hr>

<div align="center">
<img width=300 src="https://storage.googleapis.com/compass-of-truth/images/PluginGui_1_1.gif"/> 
<img width=300 src="https://storage.googleapis.com/compass-of-truth/images/Plugin%20Explorer_1_2.gif"/> 
</div>
<div align="center">
<img width=300 src="https://storage.googleapis.com/compass-of-truth/images/ServerAdmin_1_2.gif"/> 
</div>
<hr>



<div align="center">
<h3><big>&#128512; &#x1F600;</big>
<br>
 Help Us
 </h3>
We have set the project up for easy contribution.
If you would like to contribute, check our forum page out, and goto our Guthub.
Download the Repo.
Then, submit a pull request.

If you would like to join the Team email us at
<a src="mailto:team@mail.compassoftruth.app">team@mail.compassoftruth.app</a>
</div>

