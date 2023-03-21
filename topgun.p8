pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
cartdata("topgun")
function _init()
    e=2.718281828459045 pi=3.14159265359
    fadblk={0,0,1,1,2,1,13,6,2,4,9,3,13,1,8,14}
    fadwht={1,2,4,11,9,13,7,7,9,10,7,10,6,6,15,7}
    splashinit()
end
   
function _update()
    if (menu==0) gameupdate()
    if (menu==1) menuupdate()
    if (menu==2) splashupdate()
    if (menu==3) scoreupdate()
end
   
function _draw()
    if (menu==0) gamedraw()
    if (menu==1) menudraw()
    if (menu==2) splashdraw()
    if (menu==3) scoredraw()
end
   
-- splash --

function splashinit()
    cls()
    pal()
    music(14)
    menu=2 t=0 tfad=0
end

function splashupdate()
    t=t+1
    if(t==510) then
        menu=1 menuinit()
    end
end
   
function splashdraw()
    if(t==125) then 
        print("on march 3, 1969 the u.s. navy",0,3,7)
        print("established an elite school of",0,11,7)
        print("the top one percent of its",0,19,7)
        print("pilots. its purpose was to teach",0,27,7)
        print("the lost art of aerial combatand",0,35,7)
        print("to insure that the handful of",0,43,7)
        print("men who graduated were the best",0,51,7)
        print("fighter pilots in the world.",0,59,7)
        print("they succeeded.",0,75,7)
        print("today, the navy calls it",0,91,7)
        print("fighter weapons school.",0,99,7)
        print("the flyers call it:",0,115,7)
    end
end

-- menu --

function menuinit()
    pal() cls()
    t=0 tfad=0 fspd=4 play=0
    palt(0, false)
    palt(15, true)
    music(16)
    menu=1 bg=0 tend=0
    col={4,7,10,9,2,7,10,9,9,2,4,7,10,9,2}
end
   
function menuupdate()
    t+=1
    if (btnp(5)) play+=1 bg=1
    if (play>=1) play+=1 tfad+=1
    if (tfad>fspd)tfad=0
    if (play>=20) cls() gameinit()
end
   
function menudraw()
    if (bg==0) then
        cls()
        rectfill(0,0,127,80,12)
        spr(60,2,1,2,1)
        spr(62,116,2,2,1)
        spr(12,12,5,4,2)
        spr(62,64,3,2,1,true)
        spr(12,90,9,4,2,true)
        spr(12,6,45,4,2,true)
        spr(62,56,49,2,1,true)
        spr(12,88,37,4,2)
        spr(12,103,55,4,2,true)
        spr(60,71,67,2,1,true)
        spr(62,39,64,2,1)
        spr(12,-15,63,4,2)
        spr(200,33,19,8,4)
        spr(4,14,26+(cos(t/60)*2),2,2)
        spr(2,100,26+(cos(t/82)*1.8),2,2)
        print("press x to play",35,99,7)
    end
    if (play>=1) then
        -- fadezone
        if (flr(tfad/fspd)==1) then
            for px=0,127 do
                for py=0,127 do
                    pset(px,py,fadepix(pget(px,py),fadblk))
                end
            end
        end
    end
end

-- game

function gameinit() -- needs sfx for jet engine--
    menu=0
    pal()
    palt(0, false)
    palt(15, true)
    music(0)
    t=0
    overt=0
    mappix=0
    maxmap=60
    mapy=maxmap mapx=0
    player = make_player(56,96)
    muz=4
    lzcol={8,9,10,7,10,9,8}
    ncols={ {0,1,5,13,6}, {0,2,13,8,14}, {0,3,5,11,10}, {0,1,1,12,7}, {0,1,2,5,13}, {0,1,1,2,8}, {0,2,4,9,10}} -- ennemies color fades {0,13,13,6,7},
    bgcols={ {2,4,14,1,3,11}, {5,13,6,2,4,9}, {0,1,13,2,8,14}, {1,2,8,0,8,9}, {2,8,14,0,9,10}, {2,9,10,5,13,14}, {1,5,6,0,2,8}} -- background color change
    dcols={ {2,8,14}, {0,1,13}, {4,9,10}, {13,6,7}, {0,5,6}, {1,2,8}, {3,11,10}}--drop color fades
    --mcols={ {0,2,4,9,10,7}, {0,1,5,13,6,7}, {0,1,3,11,6,7}}
    fcols={ {8,9,10,7}, {2,8,14,7}, {8,2,1,0}, {11,3,1,0}, {7,10,9,4}} -- fx color change
    
    mobgroup={} bullet={} xploz={} tohit={} fxs={} bar={} lzr={} smks={} 
    game={}
    game.boss=0
    game.bosstime=66
    game.lvl=1
    game.fade=1 -- trigger overlay fade
    game.fadespd=1/15
    game.overlay=1 -- choose overlay
    game.overlays={ {173,127,111,95,79} , {79,95,111,127,173} , {79,95,111,127,173,127,111,95,79} } --in / out / inout
    bar.w=33
    bar.p=5
    powershot=0 powerjauge=0 by=128
end
   
function gameupdate()
    mappix+=1
    if (mappix==8) mappix=0 mapy-=1
    if (mapy<1) mapy=maxmap mapx=flr(rnd(2))*64
    t+=1/30
    if (t>3600) t=0
    --ennemi or boss
    if (flr(rnd(20))==1 and (player.score==0 or player.score==1 or player.score%game.bosstime>1) ) then 
       pattern(flr(rnd(min(game.lvl*2.5,9))+1), flr(rnd(min(t+1.5,5))),1-rnd(2))
       --pattern(9, flr(rnd(min(t+1.5,5))),1-rnd(2))
    elseif (player.score%game.bosstime==0 and player.score>0) then
       music(18)
       mobgroup={}
       make_mob(60,-8,10) player.score+=1 by=0
    end
    if (player.score%game.bosstime==1 and by<128) then
       by+=4
       for bx=0,128,8 do
           fx(bx-rnd(16),by,rnd(.5)-.25,-1+rnd(.25),rnd(4),1/10,{7,10,10,9,9,8,2,1},.1)
       end
    end
    --gold drop every n point
    if (flr(player.score)%(game.bosstime/2)==0 and player.score>0) tmp={} tmp.x=32+rnd(32) tmp.y=-8 dodrop(tmp,1) player.score+=1
    
    foreach(bullet, move_bullet)
    move_actor(player)
    if ((btn(4)) and (bar.p>2) and (powershot<=0)) powershot=1
    if (bar.p>bar.w) bar.p=bar.w
    powershoot()
    foreach(mobgroup, move_actor)
    foreach(fxs, movefx)
    foreach(smks,smoke_update)
end
   
function gamedraw()
    draw_map(mapy,mappix)
    foreach(mobgroup, draw_shadow)
    draw_shadow(player)
    foreach(mobgroup, draw_actor)
    smoke_draw()
    foreach(fxs, drawfx)
    draw_actor(player)
    if (btn(5) and player.ready >= player.fire) muzzle(player.x,player.y-1,player.dmg) player.ready=0
    foreach(tohit, draw_hitactor)
    prev={} prev.x=0 prev.y=0
    foreach(bullet, draw_bullet)
    foreach(xploz, draw_xploz)
    if (game.fade>0) screentrans(game.overlays[game.overlay],1-game.fade,1) game.fade-=game.fadespd
    if (game.fade<0.5 and game.boss==1) game.boss=0 game.lvl+=1 music(0)
    ui()
end
   
function ui()
    print("score: "..player.score,64,3,0)
    print("score: "..player.score,63,2,10)
    local i=1
    for j=1,player.life do spr(53,88+(i*7),120) i+=1 end
    while (i<=4) do spr(54,88+(i*7),120) i+=1 end
    rectfill(1,122,3+bar.w,126,0) --black bar
    if (bar.p>2) then
        rectfill(2,123,2+bar.p,125,9) --orange bar
        pset(2,123,4) pset(2,125,4) --brown left corners
        pset(2+bar.p,123,4) pset(2+bar.p,125,4) --brown right corners
        rectfill(3,123,1+bar.p,124,10) --yellow body
        pset(3,123,9) pset(bar.p+1,123,9) -- orange round
    end
end

--arsenal

function muzzle(x,y,dmg)
    if (muz == 4) muz=11 else muz=4
    x += muz
    make_bullet (x,y,0,-5,dmg,0,1)
    line(x-1,y,x+1,y,10)
    pset(x,y,9)
    pset(x,y-1,10)
end
   
function make_bullet(x,y,dx,dy,dmg,t,fx)
    local b={}
    b.x=x
    b.y=y
    b.dx=dx
    b.dy=dy
    b.dmg=dmg
    b.type=t --0 player 1 lazor 2 ennemies
    b.fx=fx
    add(bullet,b)
    if (t==1) local l={} l.x=x l.y=y add(lzr,l)
    if (t!=1) then sfx(52,3) else sfx(12,3) end --needs sfx for rockets--
    return b
end
   
   function move_bullet(b)
    b.x+=b.dx
    b.y+=b.dy
    if (b.x>128 or b.x<0 or b.y>128 or b.y<0) del(bullet,b)
    if (b.type==0) then
     for trgt in all(mobgroup) do
      if (trgt.k==10 and trgt.y<48) break
      col=false
      if (player.dmg>6) then col=boxcol(b.x-3,b.y-8,6,7,trgt.x,trgt.y,trgt.frsize*8,trgt.frsize*8)
      elseif (player.dmg>4) then col=boxcol(b.x-2,b.y-8,4,8,trgt.x,trgt.y,trgt.frsize*8,trgt.frsize*8)
      elseif (player.dmg>2) then col=circcol(b.x,b.y,3,trgt.x,trgt.y,trgt.frsize*4)
      else col=boxcol(b.x,b.y,0,0,trgt.x,trgt.y,trgt.frsize*8,trgt.frsize*8)
      end
      if ( col==true and trgt.k>-1 ) make_xploz(b.x,b.y) add(tohit,trgt) trgt.life-=b.dmg del(bullet,b)
     end
    end
    if (b.type==1) then
     for trgt in all(mobgroup) do
      if (trgt.k==10 and trgt.y<48) break
      if (boxcol(b.x-3,b.y,8,8,trgt.x,trgt.y,trgt.frsize*8,trgt.frsize*8) and (trgt.k>-1)) make_xploz(b.x,b.y) add(tohit,trgt) trgt.life-=b.dmg del(bullet,b)
     end
    end
    if (b.type==2) then
     if (circcol(b.x,b.y,0,player.x+8.5,player.y+8.5,2)) make_xploz(b.x,b.y) add(tohit,player) player.life-=b.dmg del(bullet,b)
    end
    if (b.type==3) then
     if (circcol(b.x,b.y,3,player.x+8.5,player.y+8.5,2)) make_xploz(b.x,b.y) add(tohit,player) player.life-=b.dmg del(bullet,b)
    end
    if (b.type==4) then
     if (boxcol(b.x+2,b.y,4,8,player.x+6,wobble(player.y+5,(-.5*player.wob)),4,4)) make_xploz(b.x,b.y) add(tohit,player) player.life-=b.dmg del(bullet,b)
    end
    if (b.type==5) then
     if (boxcol(b.x+1,b.y+1,6,7,player.x+6,wobble(player.y+5,(-.5*player.wob)),4,4)) make_xploz(b.x,b.y) add(tohit,player) player.life-=b.dmg del(bullet,b)
    end
   end
   
   function draw_bullet(b)
    if (b.type==0) then
       if (player.dmg>6) then spr(57,b.x-4,b.y-8,1,1,false,true)
       elseif (player.dmg>4) then spr(55,b.x-4,b.y-8,1,1,false,true)
       elseif (player.dmg>2) then spr(56,b.x-4,b.y-6,1,1,false,true)
       else line(b.x,b.y,b.x+(b.dx*rnd(0.5)),b.y+(b.dy*rnd(0.5)),10)
       end
    end
    if (b.type==2) line(b.x,b.y,b.x+(b.dx*rnd(0.5)),b.y+(b.dy*rnd(0.5)),10)
    if (b.type==1) then
     for n=1,7 do
        spr(10,b.x-4,b.y-8,1,3,false,false)
     end
    end
    if (b.type==3) then
       spr(56,b.x,b.y)
       rstpal()
    end
    if (b.type==4) then
       spr(55,b.x,b.y)
    end
    if (b.type==5) then
       spr(57,b.x,b.y)
    end
   end
   
   function make_xploz(x,y)
    fx(x,y,0,0,5,1,{07,10,09,08},2)
    local exp={}
    exp.x=x
    exp.y=y
    exp.frame=48
    add(xploz,exp)
    --needs explosion sfx--
    return exp
   end
   
   function draw_xploz(exp)
    spr(exp.frame,exp.x,exp.y)
    exp.frame +=1
    if (exp.frame>52) del(xploz,exp)
   end
   
   function powershoot()
    if (powershot==1) powerjauge=bar.p powershot-=0.001
    if (powershot>0) then
     powershot-=2
     bar.p-=1 
     make_bullet(player.x+8,player.y-1,0,-23,8,1,1) 
     fx(player.x+4,player.y-1,rnd(.5)-.75,rnd(.5)-1,.125+rnd(.125),1/30,{10},1) 
     fx(player.x+12,player.y-1,rnd(.5)+.25,rnd(.5)-1,.125+rnd(.125),1/30,{10},1)
    end
   end
   
   -- objects
   
   function make_actor(x,y,k)
    local a={}
    a.x=x
    a.y=y
    a.k=k
    a.life=4
    a.mlife=4
    a.frame=0
    a.frsize=2
    a.ready=0
    a.shd=33
    a.radius=4
    a.wob=1
    a.dmg=1
    return a
   end
   
   function make_player(x,y)
    pl=make_actor(x,y,1)
    pl.score=0
    pl.fire=5
    pl.radius=2
    return pl
   end
   
   function make_mob(x,y,k)
    mobcol=ncols[game.lvl%(#bgcols)]
    if (k==2) mob=make_actor(x,y,k) mob.mlife=3+(game.lvl*0.25) mob.life=mob.mlife mob.fire=9 mob.frame=8 mob.shd=35 mob.col=mobcol add(mobgroup,mob)
    if (k==3 or k==4) mob=make_actor(x,y,k) mob.mlife=2+(game.lvl*0.5) mob.life=mob.mlife mob.fire=0 mob.frame=37 mob.shd=36 mob.col=mobcol mob.frsize=1 mob.franm=1 mob.anm={37,38} add(mobgroup,mob)
    if (k==5) then 
     local posmob=flr(rnd(16))
     if(fget(mget(posmob,mapy),0)) mob=make_actor(posmob*8,-7,k) mob.mlife=3 mob.life=mob.mlife mob.fire=12 mob.frame=122 mob.shd=101 mob.col=mobcol mob.frsize=1 mob.wob=0 mob.anm={107,122,122,122,122,122,122,122,122,122,107,106} mob.franm=1 add(mobgroup,mob)
    end
    if (k==6) mob=make_actor(x,y,k) mob.mlife=5+game.lvl mob.life=mob.mlife mob.fire=6 mob.frame=8 mob.shd=36 mob.col=mobcol mob.frsize=1.5 add(mobgroup,mob)
    if (k==7) mob=make_actor(x,y,k) mob.mlife=3+(game.lvl*2) mob.life=mob.mlife mob.fire=12 mob.frame=8 mob.shd=36 mob.col=mobcol mob.frsize=1.5 add(mobgroup,mob)
    if (k==8) mob=make_actor(x,y,k) mob.mlife=5*(game.lvl/2) mob.life=mob.mlife mob.fire=60-flr(rnd(20)) mob.frame=8 mob.shd=59 mob.col=mobcol mob.frsize=1.5 add(mobgroup,mob)
    if (k==9) mob=make_actor(x,y,k) mob.mlife=10*(game.lvl/3) mob.life=mob.mlife mob.fire=25+flr(rnd(10)) mob.frame=8 mob.shd=43 mob.col=mobcol mob.frsize=1.5 add(mobgroup,mob)
    if (k==10) mob=make_actor(x,y,k) mob.mlife=player.score*2 mob.life=mob.mlife mob.fire=3-game.lvl%2 mob.dmg=max(1,flr(player.dmg/1.5)) mob.frame=39 mob.shd=94 mob.frsize=3 mob.wob=0 mob.franm=1 mob.anm={39,40,41} mob.col=mobcol mob.fx=flr(rnd(5)+1) add(mobgroup,mob)
    return mob
   end
   
   function draw_actor(a)
       if(a.x>-8 and a.x<136 and a.y>-16 and a.y<144) then
        if (a.k==10) then
         --spr(37,a.x-12-outbnc(72,0,min(a.y,48),48),wobble(a.y-3,(-.5*a.wob)),1,1,true)
         --spr(37,a.x+12+outbnc(72,0,min(a.y,45),45),wobble(a.y-3,(-.5*a.wob)),1,1)
         if (a.y<48) then
           if ( outbnc(72,0,min(a.y,48),48)<=2 ) fx(a.x-4,wobble(a.y-1.5,(-.5*a.wob)),rnd(.5)-1,2-rnd(3),rnd(1)+2,rnd(.25)+.25,{7,10,9,8},0)
           if ( outbnc(72,0,min(a.y,45),45)<=2 ) fx(a.x+12,wobble(a.y-1.5,(-.5*a.wob)),rnd(.5)+0.5,2-rnd(3),rnd(1)+2,rnd(.25)+.25,{7,10,9,8},0)
         end
         rstpal()
         chngpal(dcols[1],dcols[3])
         spr(a.frame,a.x,wobble(a.y,(-.5*a.wob)),1,1)
         rstpal()
         spr(93,a.x-4,wobble(a.y-10,(-.5*a.wob)),1,3)
         spr(93,a.x+4,wobble(a.y-10,(-.5*a.wob)),1,3,true)
         spr(108,a.x-12,wobble(a.y-2,(-.5*a.wob)),1,1)
         spr(108,a.x+12,wobble(a.y-2,(-.5*a.wob)),1,1,true)
         rstpal()
        elseif (a.k>1) then
         if (a.k==4) then
           spr(a.frame,a.x,wobble(a.y,(-.5*a.wob)),a.frsize,a.frsize,true)
         elseif (a.k==6 or a.k==7) then
           frsz=flr(a.frsize)
           spr(a.frame,a.x-(frsz*4),wobble(a.y,(-.5*a.wob)),frsz,frsz)
           spr(a.frame,a.x+(frsz*4),wobble(a.y,(-.5*a.wob)),frsz,frsz,true)
         elseif (a.k==8 or a.k==9) then
           frsz=flr(a.frsize)
           spr(a.frame,a.x-(frsz*4),wobble(a.y,(-.5*a.wob)),frsz,frsz+1)
           spr(a.frame,a.x+(frsz*4),wobble(a.y,(-.5*a.wob)),frsz,frsz+1,true)
         else
           spr(a.frame,a.x,wobble(a.y,(-.5*a.wob)),a.frsize,a.frsize)
         end
         rstpal()
        elseif (a.k<0) then
         chngpal(dcols[1],a.col)
         spr(a.frame,a.x,wobble(a.y,(-.5*a.wob)),a.frsize,a.frsize)
         rstpal()
        else 
         spr(a.frame,a.x,wobble(a.y,(-.5*a.wob)),a.frsize,a.frsize)
        end
        
        if (a.k>1 and a.life<a.mlife) then
           lifebar=(a.frsize*8) * (a.life/a.mlife)
           barbnd=(a.frsize*4)
           rectfill(a.x+3-barbnd,a.y-9,a.x+3+barbnd,a.y-10,0)
           rectfill(a.x+4-barbnd,a.y-10,a.x+4-barbnd+lifebar,a.y-11,8)
        end
       end
   end
   
   function draw_hitactor(a)
    for c=0,14 do pal(c,7,0) end
    if(a.k<10) then 
       if (a.k==4) then
           spr(a.frame,a.x,wobble(a.y,(-.5*a.wob)),a.frsize,a.frsize,true)
       elseif (a.k==6 or a.k==7) then
           frsz=flr(a.frsize)
           spr(a.frame,a.x-(frsz*4),wobble(a.y,(-.5*a.wob)),frsz,frsz)
           spr(a.frame,a.x+(frsz*4),wobble(a.y,(-.5*a.wob)),frsz,frsz,true)
       elseif (a.k==8 or a.k==9) then
           frsz=flr(a.frsize)
           spr(a.frame,a.x-(frsz*4),wobble(a.y,(-.5*a.wob)),frsz,frsz+1)
           spr(a.frame,a.x+(frsz*4),wobble(a.y,(-.5*a.wob)),frsz,frsz+1,true)
       else
           spr(a.frame,a.x,wobble(a.y,(-.5*a.wob)),a.frsize,a.frsize)
       end
    else
       spr(37,a.x-12-outbnc(72,0,min(a.y,48),48),wobble(a.y-3,(-.5*a.wob)),1,1,true)
       spr(37,a.x+12+outbnc(72,0,min(a.y,45),45),wobble(a.y-3,(-.5*a.wob)),1,1)
       spr(a.frame,a.x,wobble(a.y,(-.5*a.wob)),1,1)
       spr(93,a.x-4,wobble(a.y-10,(-.5*a.wob)),1,3)
       spr(93,a.x+4,wobble(a.y-10,(-.5*a.wob)),1,3,true)
       spr(108,a.x-12,wobble(a.y-2,(-.5*a.wob)),1,1)
       spr(108,a.x+12,wobble(a.y-2,(-.5*a.wob)),1,1,true)
       spr(124,a.x-3,wobble(a.y+7,(-.5*a.wob)),1,1)
       spr(124,a.x+3,wobble(a.y+7,(-.5*a.wob)),1,1,true)
    end
    del(tohit,a)
    pal()
    palt(0, false)
    palt(15, true)
   end
   
   function move_actor(a)
    if ((a.k>1) and (circcol(a.x+flr(a.frsize)*4+0.5,a.y+flr(a.frsize)*4+0.5,a.radius,player.x+8.5,player.y+8.5,2)) and a.x>-8 and a.x<136 and a.y>-16 and a.y<144) then
     add(tohit,player) add(tohit,a) a.life-=4 player.life-=1
    end
    if (a.life <=0) then
     if (a.k>1) then
       if (a.k==10) then player.score+=10 dodrop(a,1) game.boss=1 game.fade=1 game.overlay=3 game.fadespd=1/30 bullet={} --needs music of some sort--
       else player.score+=1 dodrop(a,.02)
       end
     end
     if (a.k==1) scoreinit()
     make_xploz(a.x+a.frsize*4+0.5,a.y+a.frsize*4+0.5) del(mobgroup,a) 
    end
    if (a.life/a.mlife<=.25) then
       smoke_make(a.x+a.frsize*2,wobble(a.y,(-.5*a.wob))-a.frsize*2,.5+rnd(.5),.1-rnd(.2),2+rnd(2),rnd(1))
    elseif (a.life/a.mlife<=.5)  then 
       smoke_make(a.x+a.frsize*2,wobble(a.y,(-.5*a.wob))-a.frsize*2,.5+rnd(.5),.1-rnd(.2),1+rnd(1),rnd(.75))
    end
    if (a.k==1) then --player move
     a.frame=0
     a.shd=33
     if (a.ready < a.fire) a.ready+=1
     if (btn(4) or btn(5)) then
      speed=1.3
     else
      speed=1.9
     end
     if (btn(0)) a.x-=speed a.frame=2 a.shd=32 fx(a.x+1,a.y+8,-0.025,1+rnd(.25),rnd(.25)+0.25,1/30,{7,6,5},0) fx(a.x+15,a.y,0.025,1+rnd(.25),rnd(.25)+0.25,1/30,{7,6,5},0)
     if (btn(1)) a.x+=speed  a.frame=4 a.shd=34 fx(a.x+1,a.y,-.025,1+rnd(.25),rnd(.25)+0.25,1/30,{7,6,5},0) fx(a.x+15,a.y+8,.025,1+rnd(.25),rnd(.25)+0.25,1/30,{7,6,5},0)
     if (btn(2)) a.y-=speed 
     if (btn(3)) a.y+=speed 
     if (a.y < -4)  a.y=-4
     if (a.y > 120) a.y=120
     if (a.x < -4)  a.x=-4
     if (a.x > 116) a.x=116
    end
    if (a.k==2) then
     a.y+=1.5 fx(a.x+11,a.y+2,0,-1-rnd(.25),rnd(.2),1/30,{10,9,8},0) fx(a.x+4,a.y+2,0,-1-rnd(.25),rnd(.2),1/30,{10,9,8},0)
     if (a.y>130) del(mobgroup,a)
    end
    if (a.k==3) then
     a.x-=1 a.y+=.75 a.franm+=0.1
     if(a.franm >= count(a.anm)+1) then a.franm=1 end 
     a.frame=a.anm[flr(a.franm)]
     if (a.y>130 or a.x<-10) del(mobgroup,a)
    end
    if (a.k==4) then
     a.x+=1 a.y+=.75 a.franm+=0.1
     if(a.franm >= count(a.anm)+1) then a.franm=1 end 
     a.frame=a.anm[flr(a.franm)]
     if (a.y>130 or a.x>130) del(mobgroup,a)
    end
    if (a.k==5) then --turret move
     a.y+=1 a.franm+=0.5 
     if(a.franm >= count(a.anm)+1) then a.franm=1 end 
     a.frame=a.anm[flr(a.franm)]
     if (a.frame==106) then 
      local bulx 
      local buly
      if (a.x>player.x) then
       bulx = -1 
      else 
       bulx = 1 
      end
      if (a.y>player.y) then
       buly = -1 
      else
       buly = 1
      end
      make_bullet(a.x+a.frsize*4+0.5,a.y+a.frsize*4+0.5,bulx*2,buly*3,1,2,1)
      fx(a.x+a.frsize*4+0.5,a.y+a.frsize*4+0.5,0,1,10,10*(1/count(a.anm)),{2,8,10},1) -- red indicator
     end
     if (a.y>130) del(mobgroup,a)
    end
    if (a.k==6) then
     a.y+=1.5 fx(a.x+3,a.y,0,-1-rnd(.25),rnd(.2),1/30,{10,9,8},0) fx(a.x+4,a.y,0,-1-rnd(.25),rnd(.2),1/30,{10,9,8},0)
     if (a.y>130) del(mobgroup,a)
    end
    if (a.k==7) then
     a.x+=2*cos(t/2) a.y+=1.5 fx(a.x+1,a.y-1,0,-1-rnd(.25),rnd(.2),1/30,{10,9,8},0) fx(a.x+6,a.y-1,0,-1-rnd(.25),rnd(.2),1/30,{10,9,8},0)
     if (a.y>130) del(mobgroup,a)
    end
    if (a.k==8) then
       if (a.ready < a.fire) a.ready+=1
       if (a.ready==a.fire) then
           a.ready=0 
           for i=16,22,2 do make_bullet(a.x+4,wobble(a.y+i,(-.5*a.wob)),0,5,a.dmg,2,1) end
       end
       a.y+=0.3 fx(a.x+1,a.y-1,0,-1-rnd(.25),rnd(.2),1/30,{10,9,8},0) fx(a.x+6,a.y-1,0,-1-rnd(.25),rnd(.2),1/30,{10,9,8},0)
       if (a.y>130) del(mobgroup,a)
    end
    if (a.k==9) then
       if (a.ready < a.fire) a.ready+=1
       if (a.ready==a.fire) then
           a.ready=0 
           for i=0,8,8 do make_bullet(a.x+i,wobble(a.y+16,(-.5*a.wob)),0.01-rnd(0.02),3,a.dmg,4,1) end
       end
       a.x+=sin(t/3) a.y+=0.75 fx(a.x+1,a.y-1,0,-1-rnd(.25),rnd(.2),1/30,{10,9,8},0) fx(a.x+6,a.y-1,0,-1-rnd(.25),rnd(.2),1/30,{10,9,8},0)
       if (a.y>130) del(mobgroup,a)
    end 
    if (a.k==10) then --boss move
     if (a.ready < a.fire) a.ready+=1
     if (a.y<48) a.y+=0.75
     if (a.y>=48)then 
       if(a.wob<5) a.wob+=0.5 
       a.x=60+15*sin(t/12)
     end
     a.franm+=0.5
     if (a.franm >= #a.anm+1) a.franm=1
     a.frame=a.anm[flr(a.franm)]
     if (a.y>=48 and a.ready==a.fire) then
       a.ready=0
       if (a.fx<3) for i=-1,1,2 do make_bullet(a.x+(i*12),wobble(a.y-3,(-.5*a.wob)),sin(t)*i*2,cos(t)*i*2,a.dmg,3,a.fx) end
       if (a.fx>=3) for i=-1,1,2 do make_bullet(a.x+(i*12),wobble(a.y-3,(-.5*a.wob)),(sin(cos(t/10)))*1.5,(cos(cos(t/5)))*1.5,a.dmg,3,a.fx) end
     end
    end
    
    if (a.k==-1) then --drop move
     a.y+=0.5 a.franm+=0.5 
     if(a.franm>=(count(a.anm)+1)) a.franm=1
     a.frame=a.anm[flr(a.franm)]
     if (a.y>130) del(mobgroup,a)
     if (boxcol(a.x,a.y,8,8,player.x,player.y,16,16)) bar.p+=(bar.w/20) del(mobgroup,a) --needs pickup sfx--
    end
    if (a.k==-2) then
     a.y+=0.5 a.franm+=0.5 
     if(a.franm>=(count(a.anm)+1)) a.franm=1
     a.frame=a.anm[flr(a.franm)]
     if (a.y>130) del(mobgroup,a)
     if (boxcol(a.x,a.y,8,8,player.x,player.y,16,16)) then 
      if (player.life<4) then 
       player.life+=1 --needs player life sfx--
       else
       player.dmg=min(player.dmg+1,10) --needs player life sfx--
      end
     del(mobgroup,a) 
     end
    end
   end
   
   function dodrop(a,p)
    drop=make_actor(a.x,a.y,-1) drop.life=100 drop.fire=0 drop.shd=36 drop.frsize=1 drop.wob=2 drop.franm=1 drop.anm={39,40,41}
    i=rnd(1)
    if (i>p and i>0.5) then
       return false
    elseif (i>p) then
       drop.k=-1
       add(mobgroup,drop)
    else
       drop.k=-2
       drop.col=dcols[3]
       add(mobgroup,drop)
    end
   end
   
   function pattern(k,n,p)--kind number(1>8) pos(-1>1)
    local x={} 
    local y={}
    if (n>8) n=8
    if (n<1) n=1
    
    s=rnd(2)+1
    
    if (flr(s)==1) then --hline(0.01 v to ^ .99)
     s2=((s-flr(s))*2)-1
     w=(n*16)/2  xi=56+p*(90-(n*14))
     for i=1,n do
      x[i]=xi-w+((i-1)*16)
      if(flr(i) <= n/2) then y[i]=-16-(s2*16*(i-1)) else y[i]=-16-(s2*16*(n-i)) end
     end
    end
    
    if (flr(s)==2) then --vline(0/ 0.5| 1\)
     s2=((s-flr(s))*2)-1
     for i=1,n do
      x[i]=(((p+1)/2)*(90-n*14*s2))+(i*16*s2)
      y[i]=-1*(16*i)
     end
    end
    
    for i=1,n do
       if(x[i]!=nil and x[i]>-4 and x[i]<132) then
           if(k==3) then 
           make_mob((-1*y[i])+110,x[i]/3,k)
           elseif(k==4) then
           make_mob(y[i],x[i]/3,k)
           else
           make_mob(x[i],y[i],k)
           end
       end
    end
   end
   
   
   -- environment
   
   function draw_map(pos,ofst)
    rectfill(0,0,127,127,15)
    for n=pos-17,pos do
        if (n<0) then
         map(mapx,n+maxmap,0,ofst-8+((n-pos+17)*8),16,1)
        else
         map(mapx,n,0,ofst-8+((n-pos+17)*8),16,1)
        end
    end
    rstpal()
   end
   
   function draw_shadow(actor)
    if(pget(actor.x+1,actor.y+12) == 12)
    then
     spr(actor.shd,actor.x-2,actor.y+10)
    else
     spr(actor.shd,actor.x-1,actor.y+8)
    end
   end
   
   -- scoreboard
   function scoreinit()
    --might need to stop sfx somehow?--
    --needs game over sfx--
    music(-1)
    menu=3 t=0 tfad=0 fspd=4 py=0
    scores={}
    for i=0,4 do
     add(scores,dget(i))
    end
    for i=1,#scores do
     if (player.score>scores[i]) scores[i]=player.score break
    end
    scores=sort(scores)
    for i=0,4 do
     dset(i, scores[i])
    end
   end
   
   function scoreupdate()
    tfad+=1 
    if (t<2) t+=1/30 
    if (py<128) py+=4
    if (tfad>fspd) tfad=0
    foreach(fxs,movefx)
   end
   
   function scoredraw()
    if (t<1) then
     if (flr(tfad/fspd)==1) then
      for px=0,127 do
       for py=0,127 do
        pset(px,py,fadepix(pget(px,py),fadblk))
       end
      end
     end
    else
     cls()
     print("you scored: "..player.score,38,90,9)
     spr(6,outbnc(0,48,t-1,1),16,2,2)
     spr(6,outbnc(128,64,t-1,1),16,2,2,true)
     print("game over",47,40,8)
     for n=1,#scores do
      print("number "..n.." :  "..scores[n],38,8*n+40,10)
     end
     if (btn(5) or btn(4)) cls() menuinit()
    end
    
    foreach(fxs,drawfx)
    for px=0,128,8 do
     fx(px-rnd(16),py,rnd(.5)-.25,-1+rnd(.25),rnd(4),1/10,{7,10,10,9,9,8,2,1},.1)
    end
   end
   
   -- tools
   function wobble(x,f)
    return x+(cos(t/2)*f)
   end
   
   function circcol(ax,ay,ar,bx,by,br)
    return ((ax-bx)^2+(ay-by)^2)<(ar+br)^2
   end
   
   function boxcol(ax,ay,aw,ah,bx,by,bw,bh)
    return ((abs(ax-bx)*2<=(aw+bw))and(abs(ay-by)*2<=(ah+bh)))
   end
   
   -- sparks: fx(x,y,rnd(1)-2,rnd(1)-.5,1,.33,{7,10,9,8,2},0)
   
   function fx(x,y,dx,dy,life,spd,col,t)
    local f={}
    f.x=x
    f.y=y
    f.dx=dx
    f.dy=dy
    f.life=life
    f.maxlife=life
    f.spd=spd
    f.col=col
    f.type=t
    add (fxs,f)
    return f
   end
   
   function movefx(fx)
    if (fx.life>0) then
     fx.life -= fx.spd
     fx.x += fx.dx
     fx.y += fx.dy
     else
     del(fxs,fx)
    end
    if ((fx.x>128)or(fx.y>128)or(fx.x<0)or(fx.y<0)) del(fxs,fx)
   end
   
   function drawfx(fx)
    if (#fx.col>1) then fcol=fx.col[min(#fx.col,flr((1-fx.life/fx.maxlife)*#fx.col)+1)] else fcol=fx.col[1] end
    if (fx.type==0) pset(fx.x,fx.y,fcol)
    if (fx.type==1) circ(fx.x,fx.y,fx.life,fcol)
    if (fx.type==.1) circfill(fx.x,fx.y,fx.life,fcol)
    if (fx.type==2) circ(fx.x,fx.y,1+fx.maxlife-fx.life,fcol)
    if (fx.type==-.1) circfill(fx.x,fx.y,1+fx.maxlife-fx.life,fcol)
    if (fx.type==3) spr(fcol,fx.x,fx.y,1,1)
    end
    
   function smoke_make(x,y,dx,dy,radius,life)
       local sm={}
       sm.x=x
       sm.y=y
       sm.dx=dx
       sm.dy=dy
       sm.r=1
       sm.maxr=radius
       sm.l=life
       sm.lcur=0
       add(smks,sm)
       return sm
   end
   
   function smoke_update(sm)
       if ((sm.x<=0-sm.r)or(sm.x>=128+sm.r)or(sm.y<=0-sm.r)or(sm.y>=128+sm.r)or(sm.lcur>sm.l)) del(smks,sm) return
       local lprcnt = sm.lcur/sm.l
       if (lprcnt<0.5) then
        sm.r=smhstp(0,1,lprcnt*2)*sm.maxr+sm.maxr/4
       else
        sm.r=smhstp(1,0,(lprcnt-.5)*2)*sm.maxr
       end
       sm.lcur+=1/30
       sm.x+=sm.dx
       sm.y+=sm.dy
   end
   
   function smoke_draw()
       for sm in all(smks) do circfill(sm.x,sm.y,sm.r,13) end
       for sm in all(smks) do circfill(sm.x-3*sm.r/10,sm.y-sm.r/5,4*sm.r/5,6) end
       
   end
   
   --function linear(b,e,t,d) --base,end,current time,duration
   -- if (t==0) return b
   -- c=t/d
   -- return (b + c*(e-b))
   --end
   
   --function incube(b,e,t,d)
   -- if (t==0) return b
   -- t=t/d 
   -- return (e-b)*t*t*t+b
   --end
   
   --function outcube(b,e,t,d)
   -- if (t==0) return b
   -- t=t/d-1
   -- return (e-b)*(t*t*t+1)+b
   --end
   
   --function inoutcube(b,e,t,d)
   -- if (t==0) return b
   -- t=t/d*2
   -- if (t<1) then
   --  return (e-b)/2*t*t*t+b
   -- else
   --  t=t-2
   --  return (e-b)/2*(t*t*t+2)+b
   -- end
   --end
   
   --function elastic(b,e,t,d)
   -- if(t==0) return b
   -- t=t/d
   -- if(t>=1) return e
   -- if(t>1/3) then
   --  t=3/2*(t-1/3)
   --  return sin(-2*t)*((e-b)/8)*(1-t*t)+(e-b)
   -- else
   --  t=2*t
   --  return -(e-b+((e-b)/8))*t*(t-2)+b
   -- end
   --end
   
   function outbnc(b,e,t,d)
    if (t==0) return b
    if (t>=d) return e
    t=t/d
    if (t<1/2.75) then
     return (e-b)*(7.5625*t*t)+b
    elseif (t<2/2.75) then
     t=t-(1.5/2.75)
     return (e-b)*(7.5625*t*t+0.75)+b
    elseif (t<2.5/2.75) then
     t=t-(2.25/2.75)
     return (e-b)*(7.5625*t*t+0.9375)+b
    else
     t=t-(2.625/2.75)
     return (e-b)*(7.5625*t*t+0.984375)+b
    end
   end
   
   function smhstp(a,b,x)
       x=clamp((x-a)/(b-a),0,1)
       return x*x*(3-2*x)
   end
   
   function clamp(x,a,b)
       if (x<a) x = a
       if (x>b) x = b
       return x
   end
   
   function fadepix(c,pal)
       return pal[c+1]
   end
   
   function screentrans(overlay,t,tmax)
       local o=flr(#overlay*(t/tmax))+1
       for x=0,120,8 do
           for y=0,120,8 do
               spr(overlay[o],x,y)
           end
       end
   end
   
   function sort(a)
    local b={}
    for i=1,#a do b[i]=0 end
    local siz=#a
    for i=1,siz do
     for j=1,#a-1 do
       if (a[j]>a[j+1]) then
        if (a[j]>b[i]) b[i]=a[j]
       else
        if (a[j+1]>b[i]) b[i]=a[j+1]
       end
     end
     del(a,b[i])
    end
    return b
   end
   
   function chngpal(src,dst)
    if(src!=dst and dst!=nil) for c=1,#src do pal(src[c],dst[c],0) end
   end
   
   function rstpal()
    pal()
    palt(0, false)
    palt(15, true)
   end
__gfx__
fffffff5ffffffff5ffffffffffffffffffffffffffffff5f00fffffffff0044ffffff999ffffffffff88fffffffffffffffffffffffffffffffffffffffffff
fffffff5fffffffff666ffffffffffffffffffffffff666f0a700ffffff04477ffffff555fffffffff8888ffffff6fffffffffffffffffffffffffffffffffff
ffffff666ffffffff6c66ffffffffffffffffffffff66c6ff09a7000f0047aaaffff0050500ffffffff55fffffff166fffffffffffffffffffffffffffffffff
ffffff6c6ffffffff66c66ffffffffffffffffffff66c66ff0449aa70947aa99fffff00800fffffffff55ffffffffd66ffffffffffffffffffffffffffffffff
ffffff6c6fffffffff66c6566666666ff6666666656c66ffff044499a4aa9922ffffff080ffffffffff55ffffffff1d6ffffffffffffffffffffffffffffffff
ffffff6c6ffffffffff66666666666ffff66666666666ffffff022449aa99247ffffff000fffffffff8558ffffffffddffffffffff77ffffffffffffffffffff
fffff56665ffffffffff566666666ffffff666666665ffffff09a7224a99244a000000000000000ff885588ffff666d1fffffffff777777fffffffffffffffff
fff666666666ffffffff666666666666666666666666fffffff099a72a9a47a9ff00800000800ffff8f99f8ffddd6d16ffffffff777777777fffffffffffffff
f6666666666666ffffff66666667666ff66676666666fffffff044999a9a4229ffff0000000ffffffffaffffff11dd6dfffffffff776777777ffffffffffffff
666666666666666fffff6666666676ffff6766666666ffffffff00224a9aa4a2fffff00c00ffffffffffffffffff11d6ffffff7777776666777fffffff777fff
fff667666766ffffffff6666666667ffff7666666666ffffffff09a72299a724ffffff0c0fffffffffffafffffffff6dfff777777766666667777ffff77677ff
ff66676667666fffffff66667666555ff55566676666fffffffff09994299a77ffffff0c0ffffffffffffffffffff6ddf7766777666666677777777777677fff
f6666766676666ffffff66666765f59ff95f56766666ffffffffff00224299aaffffff000ffffffffffffffffffffdd1ff77777666ddd666677766666677ffff
fffff75f57ffffffffff66f666755ffffff557666f66ffffffffffff00002299ffffff000ffffffffffaffffffffd11ffffffff7776666d666666667777777f7
fffff55f55ffffffffff6ff66ff59ffffff95ff66ff6ffffffffffffffff0022fffffff5ffffffffffffffffffff1fffffffffffff77777777777777ffffffff
fffff99f99fffffffffffff6ffffffffffffffff6fffffffffffffffffffff00fffffff5ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
00fffffffff0ffffffffff00fff0ffffffffffff166d1fffdd11fffffffffffffffffffffffffffffffffffffff0ffff00000000000000000000000000000000
00000000fff0ffff00000000f00000fffffffffff1666d1f666d11fffff88ffffff88ffffff88fffffffffffff000fff00000000000000000000000000000000
f000000fff000ffff000000fff000fffffffffff1dd666df1dddd6d1ff8e88ffff8e88ffff8eeeffffffaffffff0ffff00000000000000000000000000000000
f00000fff00000ffff00000f0000000ffff000ffd6666661dd666661f888882ff888888ffeee882ffffffffffff00fff00000000000000000000000000000000
f00000000000000f0000000ff00000ffff00000fddddddd1551dd551f888882ffe888eeff888882ffffffffffff00fff00000000000000000000000000000000
f000000fff000ffff000000fff000ffffff000ff1d5555dff165551fff8882ffffeee2ffff8882fffffffffff000000f00000000000000000000000000000000
f00f00fff00000ffff00f00ffff0fffffffffffff1dddd1f16d11ffffff22ffffff22ffffff22fffffffffff0000000000000000000000000000000000000000
f0ff0fffff0f0ffffff0ff0ffff0ffffffffffff166d1fffffffffffffffffffffffffffffffffffffaffffff000000f00000000000000000000000000000000
ffffffffffffffffffffff88ff2f22ffff2ffffff8080ffff0111ffffffffffffffffffffffffffffffffffff0f00f0fffffffffffffffffffffffffffffffff
ffffffffffff8ffffff9889ff89fa82fffffff8f8e88e0ff011111fffffaaffffffffffffffffffffffffffff000000ffff7ffffffffffffffff77ffffffffff
ffffa8ffff99a9fff8989aff298f9982ffff8fff8888e0ff011111fffff55ffffffffffffffaaffffffffffff0f00f0fff7777fffffffffffff77777ff77ffff
fff979fff9a77a9f8a98a98f8a9f988228fff2fff88e0ffff0111ffffff55ffffffaaffffff55ffffffffffffff0fffff776777fffffffffff777777777777ff
ff979ffff8a7798f8a99aa98f2ffff2f2ffffff2ffe0ffffff01fffffff55ffffff55ffffff55ffffffffffffff00fff77666777f77fffff777666677766677f
ff8afffff89aa8ff8aaaa98fffffaffffffffffffffffffffffffffffff55ffffffffffffff55fffffffffffff0000fff66dd66676777ff7f666ddd666767fff
ffffffffff89ff8ff8aa98fffff289ffff9ff8fffffffffffffffffffff55fffffffffffffffffffffffffffff0000ffffff7dd667fffffffff77666677fffff
ffffffffffffffffff898ffffff9822fff2ffffffffffffffffffffffffffffffffffffffffffffffffffffffff00fffffffffffffffffffffffffffffffffff
444ffffffffff4444444444444444444ffffffffffffffff444444444444444444444444444444445555555555555555444666666666666666666444ffffffff
442ffffffffff2444444444444444444ffffffffffffffff444444444444444444454444444444445155555555555555446555555555555555555644fff0ffff
442ffffffffff2444444422222244444ffffffffffffffff444445444554444444451445544443445555555515511555465555555555555555555564ffffffff
4eeffffffffffe444444222222222444ffffffffffffffff444455155551544454455141554551445555515551165555455511111111111111115554f0ffffff
444ffffffffff444444422f222222244ffffffeefeffffff445555555555515155555555555551445555111551455565455111111111111111111554ffff0fff
442ffffffffff24444422ffffff22244ffffff44e4ffffff441555555555555555555555555514445555544114415555455000000000000000000554ffffffff
442ffffffffff2444442ffffffff2444fffffe4444efffff444155555555555566555565555555545551154444445555455111111111111111111554ffffffff
44effffffffff2444442fffffffff444fffff444444fffff4445555555555666555155566655551355151144444555554551111111111111111115540fffffff
444ffffffffffe44444ffffffffff244fffff444444fffff445555555555555551115555555551115555544444451555fffafffff000a000f000000fffffffff
444fffffffffe444444ffffffffff244fffff224442fffff441155555555555511155555555551445511144444415555ffafffaaf00a8a08f500005ffff00fff
444effffffff4444444efffffffff444fffff222222fffff444555555665555555555555555555445516544444441555fffafa7fff00a008ff5005ffffffffff
4444ffffffff44444444efffffffe444ffffff22222fffff445555555515555556655555665155545555144544451555ffffa7fffff000080000000000ffffff
4444ffffffff244444444effffee4444fffffff222ffffff445555555115655655555666551555145551155554415555fffa7ffffffff0005000000500ff00ff
4442ffffffff2244444444eeee444444ffffffffffffffff455566555111566555515555555555146651555555455555fffa7fffffffff00f500005fffff00ff
4442ffffffff2e444444444444444444ffffffffffffffff415555555551155555511155555555145555556555555665ffff7fffffffff00ff5005ffffffffff
4442fffffffff4444444444444444444ffffffffffffffff441555556655555555551115555551145555555555555555fffaffffffffff00fff00fff0ffffff0
444ffffffffff244444444444444444444444444ffffffff44155555555555555555555555551144fffffffffffffffffffffffffffff000ffff651d00f00ff0
442ffffffffff224424224444424444444444444ffffffff44455555556555555555555555555434ff6666ffff6666fffffffffffffff000ff16d15dfff00fff
442ffffffffff224222222222222442244444444ffffffff44455555555665555555556555115511f6dddd6ff6dddd6ffff5000000000008166d155600ffffff
422fffffffffff24222222222222222244444444ffffffff44415666555555555555565555555554fd1111dffdd11ddffff5000000aaa088ddddd66600ff00ff
42ffffffffffffe4ff2ff22f22f2222244444444ffffffff44411555555555555555555555555514fd0000dffd1001dffff5f00000a8a08cff115dd600ff00ff
4effffffffffff44ffffffffffff22ff44444444ffffffff44441555555515555566555565555514f6dddddff6dddddffff5ff0000aaa008ffff115dffff00ff
44effffffffffe44ffffffffffffffff44444444ffffffff44445555551155555555555556511144f16d6d0ff16d6d0ffff5ff6000000000ffffff19ffffffff
444ffffffffff444ffffffffffffffff44444444ffffffff44455555555555555555555555551444ff1010ffff1010fffff9ff6600000000fffffff100f00ff0
442ffffffffff244fffffffffffffffff11fffffffffffff44555566555555655665555555551444fffffffffffffff1ffffff55ff600000fd6661ff00000f00
44effffffffffe44ffffffffffffffff1ff1ffffffffffff44415555555555566555555555511444ff6666fff111ff1fffffffffff66f00cd6ddd651ff000fff
444fffffffffe444ffffffffffffffffffffffffffffffff44441555555555551555555151514444f6dddd6ffff0110fffffffffff55ff0c6d1f195600000ff0
444eefffffff4444ffffffffffffffffffffffffffffffff44445551515551511555551111134444fddddddf1f1000ffffffffffffffff0061ffff1d00f00000
44444fffffff4444efffeefffffffffeffffffffffffffff44431151111511114151511444144444fd1111df0100001fffffffffffffff00d6fffffd00f00000
44442fffffff24444eee44efffeeefe4fffffffff1ffffff44411114141111444151114444444444f6dddddfff0f000fffffffffffffff00fd6ffff1fff0000f
44422fffffff24444444444eee444e44ffffffff1fff11ff44444414444114444414144444444444f16d6d0ff10fff01ffffffffffffff55ffd51fff000fff00
4442ffffffff22444444444444444444ffffffffffffffff44444444444444444444444444444444ff1010ff1ffffffffffffffffffffff5ffffffff00000f00
67b47686758685a5b5a4974646464646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46464646464624265556453634464646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46678777b48586a48797464646464646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d4d4d4e4464607565656475645344646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2634464667b4a4974646462436344646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46c4e446c4e425545756443727354646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
56453446466797464646245556453446000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46464646464646253727354664749446000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
57564534464646464646075656571746000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
466484944646243626344664b576a594000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
56565616466484749446044756443546000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4665a4972436555656453465758685a5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
56565617466575869546075644354664000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
466797460756565647561567b47686a4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
565647144667b4869646075645344665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46464624555656565656453467877797000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
56565645344666769524555647453466000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
24362655565656565656564534464646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
56565656154667879725545656561565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05565657565656565656475615464646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
47565756453446649446075656443566000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07565656565656565656565617464646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
37545656443546679746055756453467000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
25545656443727372737545645363446000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46253727354664748494255444273546000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46253727354664748494255444273546000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
464646464664b5758596462535c4e446000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
464646464664b5758596462535c4e446000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46464664946777878797464646464646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46464664946777878797464646464646000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46464667974646464646c4e446462436000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46464667974646464646c4e446462436000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c4d4e44646c4d4e4464646464646075600000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
c4d4e44646c4d4e4464646464646075600000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
d4e4464646c4d4d4e44646464624555700000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
d4e4464646c4d4d4e44646464624555700000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
4646464646464646464646462455565600000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
4646464646464646464646462455565600000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
46c4e44646c4d4d4e44646245557443700000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
46c4e44646c4d4d4e446462455574437000000000000000000000000000000001111111111111111111ff111ff1111ffff111ff11f11f11ff111111111111111
4646464646464646464624555644354600000000000000000000000000000000f111111111111111111f11111f11111ff11111f11f11f11ff11111111111111f
4646464646464646464624555644354600000000000000000000000000000000ffffffffffffff11ffff11f11f11f11ff11f11f11f11f111f11fffffffffffff
4646242626344646464605564435466700000000000000000000000000000000ff88888888888f11ffff11f11f11f11ff11f11f11f11f111f11f8888888888ff
4646242626344646464605564435466700000000000000000000000000000000fff8888888888f11ffff11f11f11f11ff11ffff11f11f111111f888888888fff
4624555656154646464606471546464600000000000000000000000000000000ffffffffffffff11ffff11f11f11111ff11f11f11f11f111111fffffffffffff
4624555656154646464606471546464600000000000000000000000000000000ffff888888888f11ffff11f11f1111fff11f11f11f11f111111f88888888ffff
3655565657453634464605564435466700000000000000000000000000000000fffff88888888f11ffff11f11f11fffff11f11f11f11f11f111f8888888fffff
3655565657453634464605564435466700000000000000000000000000000000ffffffffffffff11ffff11f11f11fffff11f11f11f11f11f111fffffffffffff
5747565656565617464606561546464600000000000000000000000000000000ffffff8888888f11ffff11111f11fffff11111f11111f11ff11f888888ffffff
5747565656565617464606561546464600000000000000000000000000000000fffffff888888f11fffff111ff11ffffff111fff111ff11ff11f88888fffffff
5644273754564745344625273546464600000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
5644273754564745344625273546464600000000000000000000000000000000ffffffff1111111111111111111111f11f1111111111111111111111ffffffff
5615464604565656453446464646243600000000000000000000000000000000fffffffff11111111111111111111ff11ff11111111111111111111fffffffff
5615464604565656453446464646243600000000000000000000000000000000ffffffffffffffffffffffffffffff1111ffffffffffffffffffffffffffffff
2735464625545656561746464646055600000000000000000000000000000000fffffffffffffffffffffffffff1111111111fffffffffffffffffffffffffff
2735464625545656561746464646055600000000000000000000000000000000fffffffffffffffffffffffffffff111111fffffffffffffffffffffffffffff
4664749446065656471546464624555600000000000000000000000000000000ffffffffffffffffffffffffffffff1111ffffffffffffffffffffffffffffff
4664749446065656471546464624555600000000000000000000000000000000fffffffffffffffffffffffffffff11ff11fffffffffffffffffffffffffffff
64b5759546055656564534464607565600000000000000000000000000000000fffffffffffffffffffffffffffff1ffff1fffffffffffffffffffffffffffff
64b5759546055656564534464607565600000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
6676a49746065656564435464605475600000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
6676a49746065656564435464605475600000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
6777974646075756443546464625273700000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
6777974646075756443546464625273700000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
6446474964606565655164646442556500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000064464749646065656551646464425565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
465b5759645065657454436464706565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000465b5759645065657454436464706565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66674a7964606565654453646450746500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066674a79646065656544536464507465000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7677796464707565445364646452727300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000076777964647075654453646464527273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6464646442556565416464644648474800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000062434262635565445346484749646446000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6464644255656565616464645668584a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006554556565656551465b4a4b5a48475b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6442625575447345544364465b4a78790000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006565656574447353564a79764b576867000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6440656565714255745443764b5a49640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004565756565416464665a48495667584a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
635574656554556565655443764b5a49000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000406565656554436476784b5a5b4a7779000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6544727372457465656565544376777900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070656544734554634364767778796442000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4453646464506565754445746164646400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060654453645245655462436464644255000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
514c4d4e647065447353506571644c4d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055445346484950756565546343425565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4164646464527253646452455462436400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065416476787970656565656541524574000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7164646464646464646464507444536400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065546243644255656565746571645273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5443646442436464646442554453644200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065656554635565656565654453646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7454626355544364646440445342635500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000045756565746544727345445364646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6565656575655146484952536452724500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000052727372737353646470416464646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65746544737253767879426363436452000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000644c4e64646464644255516464646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65447253644c4e64646452454453646400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000064646464646464647075544364646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4453464964646464646442554164646400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000064646464646464645245445364646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5164767942624364644255655443646400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000064646464646464646470544364646446000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
544364425575544364524575656164640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006446474964646464645245716446485b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65546355656565616442556565516464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000465b685a494c4d4d4e64706164565867000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
656574657565656142556565657164640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005b4a78777964464749645051465b574a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
447373456565745455656565445364640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004a79464847485b586964704166576759000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
516442554473727273727273536464640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006964764b4a4b576759645253764b685a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
536452725364464748496464646464640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005964647679764b575a42634364764b58000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6464646446485b575769644243646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000594c4d4d4e645667595044536464764b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
644647485b5768684a794255414c4d4e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000696464646464664a7940516464646476000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
465b5767676867585a64524551644c4d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005a49646464647679647061644c4d4e64000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5667684a4b685868575a4952536464640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004a794c4d4e6464646460716464646464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6667685a5b57674a4b57694c4d4e6464000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000794c4e64646464644255516464644c4d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100040d6100d6150d6100d61000605076001960024605276002b60015500155001550015500155001550015500155001550015500155001550015505005000050010500105051550015505000000000000000
000c0000011450000003145001000614500100081400814008145001000614006140061450010003140031400314003140031400314003140031400314003140031450f100000000000000000000000000000000
010c00000000000000000000000000000000000000000000000000000000000000000000000000250450000027045000000000000000000000000027042270422704227045000000000027042270450000000000
000c0000000000000000000000000000000000000000000000000000000000000000000000000019045000001b04500000000000000000000000001b0421b0421b0421b04500000000001b0421b0450000000000
010c000000000000000000000000000000000000000000000000000000000000000000000000000c043000000000000000246150000000000000000c043000000c04300000246150000000000000000c04300000
010c0000000000000024615000003c600000000c043000000c04300000246150000000000000000c043000000000000000246150000000000000000c043000000c04300000246150000000000000000c04300000
000c00002704500000270450000027042270422704500000270422704227042270450000000000250450000027045000000000000000000000000027042270422704227045000000000027042270422704500000
000c00001b045180001b045180001b0421b0421b045180001b0421b0421b0421b045000000000019045000001b04500000000000000000000000001b0421b0421b0421b04500000000001b0421b0421b04500000
000c0000270422704527042270452a0422a0422a0422a0452a0422a0422a0422a0452504225042250422504225042250422504225042250422504225042250422504225042250422504225042250422504225042
000c00001b0421b0451b0421b0451e0421e0421e0421e0451e0421e0421e0421e0451904219042190421904219042190421904219042190421904219042190421904219042190421904219042190421904219042
000c00002504225042250422504225042250422504225042250422504225042250422504500000250450000027045000000000000000000000000027042270422704227045000000000027042270450000000000
000c0000190421904219042190421904219042190421904219042190421904219042190450000019045180001b04518000180001800018000180001b0421b0421b0421b04518000180001b0421b0451800000000
000c00002704500000270450000027042270422704500000270422704227042270450000000000250452400027045000000000000000000000000027042270422704227045000000000027042270422704500000
000c00001b045180001b045180001b0421b0421b045180001b0421b0421b0421b045180001800019045180001b04518000180001800018000180001b0421b0421b0421b04500000000001b0421b0421b04500000
000c00000605500000080550000006055000000105500000030550000000155000000105500000031400314003140031400314003140031400314500000000000000000000000000000000000000000000000000
000c00000114500000031450010006145001000814008140081450010006140061400614500100011400114001140011400114001140011400114001140011400114001140011400114503100011450000001145
000c00000000000000000000000001145000000114001140011450000001140011400114500100031400314003140031400314003140031400314503145031400314003140031400314003140031400314500000
000c00000605500000080550000006055000000105500000030550000000155000000105500000030550000006055000000805500000060550000001055000000305500000001550000001055000000305500000
000c00001b045180001b045180001b0421b0421b045000001b0421b0421b0421b04500000000001e045000001e045000001e045000001e045000001e0421e0421e0421e045160421604216045000001e04500000
000c000027045000002704500000270422704227045000002704227042270422704500000000002a045000002a045000002a045000002a045000002a0422a0422a0422a045220422204222045000002a04500000
010c00000114500000031450010006145001000814008140081450010006140061400614500000030550000006055000000805500000060550000001055000000305500000001550000001055000000305500000
000c00002a045000002a045000002a045000002904500000270450000025045000002504225042250450000027042270422704500000000000000000000000000000000000000000000000000000000000000000
000c00001e045000001e045180001e045000001d045000001b045000001904500000190421904219045000001b0421b0421b04500000000000000000000000000000000000000000000000000000000000000000
000c000000000000000000000000000000000000000000000000000000000000000000000000001e045000001e045000001e045000001e045000001e0421e0421e0421e045160421604216045000001e04500000
000c000000000000000000000000000000000000000000000000000000000000000000000000002a045000002a045000002a045000002a045000002a0422a0422a0422a045220422204222045000002a04500000
000c00002a045000002a045000002a045000002904500000270450000025045000002504225042250450000027042270422704500000000000000000000000000000000000000000000000000000000000000000
000c00001e045180001e045180001e045180001d045180001b045180001904518000190421904219045180001b0421b0421b04500000000000000000000000000000000000000000000000000000000000000000
000c000000000000000000000000000000000000000000000000000000000000000000000000002c0422c0422c0422c0422c0422c0422c045000002a0422a0422a0422a0422a0422a0422a045000002904229042
000c0000000000000000000000000000000000000000000000000000000000000000000000000020042200422004220042200422004220045180001e0421e0421e0421e0421e0421e0421e045180001d0421d042
000c00002904229042290422904229045000002504225042250422504225042250422504500000270422704227045240002704524000270422704227042270450000000000000002700000000270002700027000
000c00001d0421d0421d0421d0421d0450000019042190421904219042190421904219045000001b0421b0421b045000001b045000001b0421b0421b0421b04500000000001b000180001b0001b0001b00000000
001000000c7320c7320c7320c7320c7320c7320c7320c7320c7320c7320c7320c7320c7320c7320c7320c7320e7320e7320e7320e7320e7320e7320e7320e7320e7320e7320e7320e7320e7320e7320e7320e732
0010000010732107321073210732107321073210732107321173211732117321173210732107321073210735107321073210732107320e7320e7320e7320e7320e7320e7320e7320e7320e7320e7320e7320e732
0110000000645000050063500005006250000500615000050c645000050c635000050c625000050c615000000064500005006350000500625000050061500000006150000500615000050c6450c6450c64500000
011000000c0520c0520c0420c0320c0220c0150c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c000000000000000000000000000000000000000000000000000000000000000
011000000c1520c1520c1420c1320c1220c1150010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000073200732007320073200732007320073200732007320073200732007320073200732007320073200732007320073200732007320073200732007320073200732007320073200732007320073200732
00100000180521805218052180551f0521f0521f0521f0551f0521f0521f0521f0551d0521d0551c0521c0551d0521d0551c0521c0551a0521a0521a0521a0551a0521a0521a0521a05518052180551a0521a055
001000001c0521c0521c0521c0551a0521a0551c0521c0551d0521d0521d0521d0551c0521c05518052180551c0521c0521c0521c0551a0521a0521a0521a0521a0521a0521a0521a0521a0521a0521a0521a055
00100000185521855218552185551f5521f5521f5521f5551f5521f5521f5521f5551d5521d5551c5521c5551d5521d5551c5521c5551a5521a5521a5521a5551a5521a5521a5521a55518552185551a5521a555
001000001c5521c5521c5521c5551a5521a5551c5521c5551d5521d5521d5521d5551c5521c55518552185551c5521c5521c5521c5551a5521a5521a5521a5521a5521a5521a5521a5521a5521a5521a5521a555
010c00003c6153c6003c6153c60000000000000c625000000c6250c003246250c00300000000000c625000000c6250c003246250c00300000000000c625000000c6250c003246250000000000000000c62500000
010c00000c6250c003246250c00300000000000c625000000c6250c003246250c00300000000000c625000000c6250c003246250c00300000000000c625000000c6250c003246250c00300000000000c62500000
010c00003061530200306153060018100181000c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1350c1000c10007130071350c1300c135
010c0000246150050024615005000050000700111301113011130111301113011130111301113011130111301113011130111301113011130111301113011130111301113500100001000c1300c1351113011135
010c00001821500200182150020000200002001555015550155501555015550155501555015550155501555015550155501555015550155501555015550155501555015555001000010010550105551555015555
010c000000300003000b1300b1300b135001000b1300b135091300913009135001000913009130091300913009130091300913009130091300913009130091300913009135091000010007130071350913009135
010c000000100001001013010130101350010010130101350e1300e1300e135001000e1300e1300e1300e1300e1300e1300e1300e1300e1300e1300e1300e1300e1300e1350e100001000c1300c1350e1300e135
010c00000030000300135501355013555001001355013555115501155011555001001155011550115501155011550115501155011550115501155011550115501155011555000000010010550105551155011555
010c000000100001000b1300b1300b135001000b1300b1350c1300c1300c135001000c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c1300c135001000010007130071350c1300c135
010c0000001000010010130101301013500100101301013511130111301113500100111301113011130111301113011130111301113011130111301113011130111301113500100001000c1300c1351113011135
010c00000050000500135501355013555005001355013555155501555015555005001555015550155501555015550155501555015550155501555015550155501555015555005000050010550105551555015555
010a00002f6232362316600101001010500100101001010511100111001110500100111001110011100111001110011100111001110011100111001110011100111001110500100001000c1000c1051110011105
000c00000050000500135001350013505005001350013505155001550015505005001550015500155001550015500155001550015500155001550015500155001550015505005000050010500105051550015505
000c00003c6053c6003c6053c60000000000000c605000000c6050c003246050c00300000000000c605000000c6050c003246050c00300000000000c605000000c6050c003246050000000000000000c60500000
000c00000c6050c003246050c00300000000000c605000000c6050c003246050c00300000000000c605000000c6050c003246050c00300000000000c605000000c6050c003246050c00300000000000c60500000
000c00003060530200306053060018100181000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1050c1000c10007100071050c1000c105
000c0000246050050024605005000050000700111001110011100111001110011100111001110011100111001110011100111001110011100111001110011100111001110500100001000c1000c1051110011105
000c00001820500200182050020000200002001550015500155001550015500155001550015500155001550015500155001550015500155001550015500155001550015505001000010010500105051550015505
000c000000300003000b1000b1000b105001000b1000b105091000910009105001000910009100091000910009100091000910009100091000910009100091000910009105091000010007100071050910009105
000c000000100001001010010100101050010010100101050e1000e1000e105001000e1000e1000e1000e1000e1000e1000e1000e1000e1000e1000e1000e1000e1000e1050e100001000c1000c1050e1000e105
000c00000030000300135001350013505001001350013505115001150011505001001150011500115001150011500115001150011500115001150011500115001150011505000000010010500105051150011505
000c000000100001000b1000b1000b105001000b1000b1050c1000c1000c105001000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c1000c105001000010007100071050c1000c105
000c0000001000010010100101001010500100101001010511100111001110500100111001110011100111001110011100111001110011100111001110011100111001110500100001000c1000c1051110011105
__music__
00 01020304
00 01060705
00 0f080905
00 100a0b05
00 010c0d05
00 14131205
01 11151605
00 11181705
00 11191a05
00 0e1b1c05
00 011d1e05
00 011b1c05
00 011d1e05
02 14181705
00 21424345
03 21222324
01 2125271f
02 21262820
00 292b2c2d
01 2a2e2f30
02 2a313233
00 616b6c73
00 616e6d74
00 616b6c73
00 616f7075
00 61656771
02 61666872
00 696b6c6d
01 6a6e6f70
02 6a717273

