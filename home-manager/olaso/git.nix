{ ... }: {
  programs.git = {
    enable = true;
    settings.user = {
      name  = "mateusOlaso";
      email = "mateus@olaso.com.br";
    };
  };
}
