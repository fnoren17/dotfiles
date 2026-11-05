# Fusklapp

Leader = **Space**. Tryck Space och vänta så visar which-key resten.
`ö` = `[` och `ä` = `]` (föregående / nästa), t.ex. `äh` nästa git-ändring.
`Space fk` = sökbar lista över alla kortkommandon. Stäng den här med `q`.

## Starta / byta projekt

| Tangent              | Vad                                               |
|----------------------|---------------------------------------------------|
| `Super+N`            | Öppna / fokusera Neovim Dev                        |
| `Super+Space` → namn | Öppna projekt via launchern, t.ex. "core"          |
| `Alt+p`              | Projektväljare (● = körs redan)                    |
| `Ctrl+b f`           | Projektväljare (samma som Alt+p)                   |
| `Ctrl+b s`           | Lista sessioner som körs                           |
| `Ctrl+b (` / `)`     | Föregående / nästa session                         |
| `Ctrl+b L`           | Senaste sessionen (växla mellan två projekt)       |
| `Ctrl+b X`           | Stäng projektet (frigör nvim + LSP:er)             |
| `Ctrl+b c`           | Nytt tmux-fönster i projektet                      |
| `Ctrl+b %` / `"`     | Dela vertikalt / horisontellt                      |
| `Ctrl+b ?`           | Alla tmux-bindningar                               |

## Filer och sök

| Tangent            | Vad                                   |
|--------------------|---------------------------------------|
| `Ctrl+n`           | Filträd (explorer)                    |
| `Ctrl+p` / `Space ff` | Sök filer                          |
| `Space Space`      | Smart sök                             |
| `Space fg`         | Sök text i projektet                  |
| `Space fw`         | Sök ordet under markören              |
| `Space fr`         | Senaste filer                         |
| `Space fb`         | Öppna buffertar                       |
| `Space /`          | Sök i aktuell fil                     |

**I explorern:** `Enter`/`l` öppna, `h` stäng mapp, `a` ny fil (slutar på `/` = mapp),
`r` byt namn, `d` ta bort, `c` kopiera, `m` flytta, `H` dolda, `I` gitignorerade, `?` hjälp.

## Flikar och fönster

| Tangent              | Vad                                  |
|----------------------|--------------------------------------|
| `Shift+h` / `Shift+l`| Föregående / nästa flik              |
| `Space 1`–`5`        | Gå till flik 1–5                     |
| `Space bd`           | Stäng flik                           |
| `Space bo`           | Stäng andra flikar                   |
| `Space bp`           | Fäst flik                            |
| `Ctrl+h/j/k/l`       | Flytta mellan fönster (t.ex. explorer ↔ fil) |

## Kod (LSP)

| Tangent              | Vad                                  |
|----------------------|--------------------------------------|
| `gd` / `gy` / `gI`   | Definition / typ / implementation    |
| `gr`                 | Referenser                           |
| `K`                  | Dokumentation                        |
| `Space ca`           | Code actions                         |
| `F2` / `Space rn`    | Byt namn                             |
| `Space e`            | Fel på raden                         |
| `Space xx` / `Space xd` | Fellista projekt / fil            |
| `Space fs` / `Space fS` | Symboler fil / projekt            |
| `Space fd`           | Diagnostik i picker                  |
| `Ctrl+Alt+f`         | Formatera (sker även vid spara)      |

## Git

| Tangent              | Vad                                  |
|----------------------|--------------------------------------|
| `äh` / `öh`          | Nästa / föregående ändring           |
| `Space hp`           | Förhandsgranska ändring              |
| `Space hs` / `Space hr` | Stagea / återställ ändring        |
| `Space hb`           | Blame för raden                      |
| `Space gs`           | Git status                           |
| `Space gl`           | Git-logg för filen                   |

## Från Zed

| Tangent              | Vad                                  |
|----------------------|--------------------------------------|
| `Ctrl+Alt+s`         | Spara alla                           |
| `Alt+Shift+↑/↓`      | Duplicera rad                        |

## Multi-cursor

| Tangent              | Vad                                  |
|----------------------|--------------------------------------|
| `Ctrl+d`             | Lägg till cursor på nästa förekomst  |
| `Ctrl+Shift+d`       | Hoppa över nästa förekomst           |
| `Ctrl+Shift+↑/↓`     | Lägg till cursor ovanför / under     |
| `Space ma`           | Cursor på alla förekomster           |
| `←` / `→`            | Byt aktiv cursor                     |
| `Space mx`           | Ta bort aktiv cursor                 |
| `Esc`                | Ta bort alla extra cursors           |

Ctrl+d scrollar inte längre nedåt: använd `Ctrl+f` (helsida ned), `}` eller sök. `Ctrl+u` scrollar fortfarande upp.
Redigera med vanliga vim-kommandon, t.ex. `c` (ändra), `i`, `a`.

## Övrigt

| Tangent              | Vad                                  |
|----------------------|--------------------------------------|
| `Space qs`           | Återställ sessionen (öppna filer)    |
| `Space ?`            | Den här fusklappen (`?` = Shift+plus) |

## Vim-grunder

`i` skriv · `Esc` normal-läge · `:w` spara · `:q` stäng · `u` ångra · `Ctrl+r` gör om
`dd` ta bort rad · `yy` kopiera rad · `p` klistra in · `ciw` ändra ord · `.` upprepa
`w`/`b` ord framåt/bakåt · `gg`/`G` början/slut · `%` matchande parentes
`äd`/`öd` nästa/föregående fel · `}`/`{` (AltGr+0/7) nästa/föregående stycke
`:Tutor` = interaktiv vim-kurs (~20 min)
