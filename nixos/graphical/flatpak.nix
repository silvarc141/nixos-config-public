{...}:{
  services.flatpak.enable = true;
  custom.ephemeral = {
    data.directories = [
      "/var/lib/flatpak/"
    ];
  };
}
