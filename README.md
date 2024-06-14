![Logo](https://i.imgur.com/uv0El0Z.jpeg)

# Mythic Framework [![Awesome](https://cdn.jsdelivr.net/gh/sindresorhus/awesome@d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome#readme)
> A curated list of credits, links, and community information related to the framework.

## Description

- Custom written framework that was used for Mythic RP

## Official Discord
- [Discord Link](https://discord.gg/N2JARAe8Rp) - Offical Discord for community-driven support forum!

## Project Maintainers
- Treyyyy - Maintainer & Community Owner
- Jay - Maintainer &
- Nex - Maintainer
- TheCasual420Gamer - Maintainer
- Tyh - Maintainer
- PLACEHOLDER - Maintainer

## Credits
- Alzar & Dr Nick - Original Maintainers and Creators
- Greve - Creator of the txAdminRecipe for mythic framework




## Information

# 🚧DISCLAIMER🚧
We do not own this framework, and we am simply trying to give it the support it deserves. The framework was originally built by Alzar & Dr Nick. Alzar has taken the liberty of releasing the framework, which you can find by following the [original repository](https://github.com/Alzar/mythic-framework) 

## DO NOT FORGET TO CHANGE THE LICENSE KEYS in `environment.cfg`
Rename `example.environment.cfg` to `environment.cfg`
```cfg
# License Key
sv_licenseKey setme
set steam_webApiKey "setme"
```

# Requirements 
| Packages          | Link                                                                |
| ----------------- | ------------------------------------------------------------------ |
| PNPM | [Download Here](https://pnpm.io/installation) |
| NodeJS | [Download Here](https://nodejs.org/en/download?text=+) |
| MongoDB | [Download Here](https://www.mongodb.com/try/download/community) (v6.0.5) |
| MariaDB | [Download Here](https://mariadb.org/download/?t=mariadb&p=mariadb&r=10.6.12&os=windows&cpu=x86_64&pkg=msi&m=acorn) (v10.6.12)
| HeidiSQL | [Download Here](https://www.heidisql.com/download.php) (*can be installed via MariaDB)
  
# SQL Instaliation
Run the SQL provided in HeidiSQL, the mongo will build itself as the server starts

# NOTE:
This will not work out of the box, you will need to make modifications to the base to replace the WebAPI calls with whatever authentication source you're wanting to do. 

## Using Admin

In the MongoDB Compass, inside of the "auth" database under users, find yourself (or whoever you want to give admin too) and add a new dataset under the groups array called either admin, owner, or staff. If you're already in the server, soft or hard relog to retrieve the new permissions.

To use the admin tool, run `/admin` or `/staff`.

## Map Dependencies
This is a map list used by **Mythic Framework** for business, government ect.
Most of these maps are automatically started by the server (the ones that are not, will be signed with a "*") since they are already included in the **resources.cfg** file:

- [cfx-gabz-*](https://fivem.gabzv.com/category/subscription) (all the maps are used)
- [cfx_gn_burgershot](https://gnstud.io/products/burgershot)
- [cfx_gn_bx_food_props](https://gnstud.io/collections/props)
- [gn_saloon](https://gnstud.io/products/black-woods-saloon)
- [mz_hospital](https://gnstud.io/collections/medical/products/mount-zonah-hospital)
- [dolu_last_train](https://dolu.tebex.io/package/4465265)
- [dolu_shells](https://dolu.tebex.io/package/5141128)
- [cafe_prego](https://artex.tebex.io/package/6084340)
- [noodle_exchange](https://fivem.map4all-shop.com/package/4967545)
- [xerogasstation](https://fivem.map4all-shop.com/package/5342855)
- [artgallery](https://www.k4mb1maps.com/package/4672250)
- [digital_den](https://patoche-mapping.tebex.io/package/5171582)
- [Auto Exotics](https://lb-customs.tebex.io/package/4339272) *
- [Smoke on the Water](https://mrhunter.tebex.io/package/5198707) *
- [Ferrari Pawnshop](https://www.k4mb1maps.com/package/4672248) *
- [Dreamworks Mechanics](https://juniors-interiors.tebex.io/category/1930382) *
- [Dynasty8 real estate agency](https://forum.cfx.re/t/mlo-dynasty8-real-estate-agency/1842152) *
- **rockford_records** he shut down his tebex :|
- **nutt_sagma** he shut down his tebex :|
- **tobii-mineshaft** he shut down his patreon :|
- **tobii-fightclub** he shut down his patreon :|

