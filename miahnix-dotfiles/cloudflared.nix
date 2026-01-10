{
	services.cloudflared = {
		enable = true;
		tunnels = { 
			#"16bdfbdd-0311-4816-ac9f-0f7a7143acfa" = {
			"55208391-19f7-4f6e-bfde-19d457927e62" = {
				credentialsFile = "/etc/cloudflared/55208391-19f7-4f6e-bfde-19d457927e62.json";
				ingress = {
					"ssh.miahnix.com" = "ssh://192.168.12.222:22";
					"www.miahnix.com" = "http://192.168.12.222:80";
				};
				default = "http_status:404";
			};
		};
	};
}
