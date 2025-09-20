{
  abbrev = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hj2qyx7rzpc7awhvqlm597x7qdxwi4kkml4aqnp5jylmsm4w6xd";
      type = "gem";
    };
    version = "0.1.2";
  };
  bigdecimal = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k6qzammv9r6b2cw3siasaik18i6wjc5m0gw5nfdc6jj64h79z1g";
      type = "gem";
    };
    version = "3.1.9";
  };
  cairo = {
    dependencies = ["native-package-installer" "pkg-config" "red-colors"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f68in5svr67hvwffjhxd0kxzvv9mh0hxr1q98if73r6xnwajq8p";
      type = "gem";
    };
    version = "1.17.14";
  };
  cairo-gobject = {
    dependencies = ["cairo" "glib2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lrjabnl0nk86m89mcjhw93dwgn16hjka38508dy2w66w421pqm3";
      type = "gem";
    };
    version = "4.2.7";
  };
  classy_hash = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01b1zv6k47pxsrxqzfdvjhdlh51ldzw3drndnz8h09iklvvg6dhc";
      type = "gem";
    };
    version = "1.0.0";
  };
  csv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kmx36jjh2sahd989vcvw74lrlv07dqc3rnxchc5sj2ywqsw3w3g";
      type = "gem";
    };
    version = "3.3.2";
  };
  fiddle = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1as92bp6pgkab73kj3mh5d1idjr9wykczz7r9i1pkn82wq4xks3r";
      type = "gem";
    };
    version = "1.1.6";
  };
  gdk_pixbuf2 = {
    dependencies = ["gio2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dwpyawynrbblgzhcazhr868dqlrjbki9h08nsvm2270k6g0qq9m";
      type = "gem";
    };
    version = "4.2.7";
  };
  gio2 = {
    dependencies = ["fiddle" "gobject-introspection"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c7zziyadmra5mi73pp4xi9ww9sl9s3s1ryfh1cy3pls7brbblq8";
      type = "gem";
    };
    version = "4.2.7";
  };
  glib2 = {
    dependencies = ["native-package-installer" "pkg-config"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r1j4affv6ch57rzkf2rkziairhpr3r9l5zhgzacy792gxzndl71";
      type = "gem";
    };
    version = "4.2.7";
  };
  gobject-introspection = {
    dependencies = ["glib2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q63nrg8f34gb3wqkasdfx82ivzra3fbwski8cq2pllbjgvg7480";
      type = "gem";
    };
    version = "4.2.7";
  };
  highline = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f8cr014j7mdqpdb9q17fp5vb5b8n1pswqaif91s3ylg5x3pygfn";
      type = "gem";
    };
    version = "2.1.0";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p4l5ycdxfsr8b51gnvlvhq6s21vmx9z4x617003zbqv3bcqmj6x";
      type = "gem";
    };
    version = "2.10.1";
  };
  matrix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h2cgkpzkh3dd0flnnwfq6f3nl2b1zff9lvqz8xs853ssv5kq23i";
      type = "gem";
    };
    version = "0.4.2";
  };
  mercenary = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f2i827w4lmsizrxixsrv2ssa3gk1b7lmqh8brk8ijmdb551wnmj";
      type = "gem";
    };
    version = "0.4.0";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x8asxl83msn815lwmb2d7q5p29p7drhjv5va0byhk60v9n16iwf";
      type = "gem";
    };
    version = "2.8.8";
  };
  native-package-installer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bvr9q7qwbmg9jfg85r1i5l7d0yxlgp0l2jg62j921vm49mipd7v";
      type = "gem";
    };
    version = "1.1.9";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0npx535cs8qc33n0lpbbwl0p9fi3a5bczn6ayqhxvknh9yqw77vb";
      type = "gem";
    };
    version = "1.18.3";
  };
  pango = {
    dependencies = ["cairo-gobject" "gobject-introspection"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01qi5m2s0xgys26nfgq6f2ccrfxc208zyf4qv8p32q5696dsxd0i";
      type = "gem";
    };
    version = "4.2.7";
  };
  pkg-config = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0834vr2wxqfi3v4kzafgb90q9jda9828jbj87ds6fxgnknyd4xcv";
      type = "gem";
    };
    version = "1.5.9";
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rainbow = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  red-colors = {
    dependencies = ["json" "matrix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16lj0h6gzmc07xp5rhq5b7c1carajjzmyr27m96c99icg2hfnmi3";
      type = "gem";
    };
    version = "0.4.0";
  };
  roo = {
    dependencies = ["nokogiri" "rubyzip"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03p7ic7z7yw7mh4wg3pq7av1addxp5gq673j9gki1hgrap4kpd6b";
      type = "gem";
    };
    version = "2.10.1";
  };
  rsvg2 = {
    dependencies = ["cairo-gobject" "gdk_pixbuf2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09jfalxiz8384lfkf776iy522ljcd3rgj6565m34vdf279ad4mmm";
      type = "gem";
    };
    version = "4.2.7";
  };
  ruby-progressbar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  rubyzip = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05an0wz87vkmqwcwyh5rjiaavydfn5f4q1lixcsqkphzvj7chxw5";
      type = "gem";
    };
    version = "2.4.1";
  };
  squib = {
    dependencies = ["cairo" "classy_hash" "gio2" "gobject-introspection" "highline" "mercenary" "nokogiri" "pango" "rainbow" "roo" "rsvg2" "ruby-progressbar"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nnvpnh8zhf9ykjvl878swq6fjfnrgx5gp2yl0nnzbk1306d458p";
      type = "gem";
    };
    version = "0.19.0";
  };
}
