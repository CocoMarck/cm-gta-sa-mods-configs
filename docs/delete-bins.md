# Delete bad bins
Eliminar binarios locos del git. Esto solo elimina del `.git` local y remoto.

#### Respaldar siempre antes de reescribir historia
```bash
git clone --mirror . /tmp/respaldo-$(date +%s).git
```

#### Quitar del tracking
```bash
git rm --cached <archivo>
```

#### Purgar de la historia, y hacerle commit.
Historia profunda, con `git-filter-repo`:
```bash
git filter-repo --strip-blobs-bigger-than 10M          # por tamaño
git filter-repo --path-glob '*.bank' --invert-paths     # por patrón
```

Commit:
```bash
git commit --amend --no-edit 
```

#### Forzar push + limpieza local
```bash
git push --force-with-lease --all 
git push --force-with-lease --tags
```

Limpieza:
```bash
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git count-objects -vH      # verificar
git cat-file -s <sha-viejo>   # debe fallar
```

#### Verificar
```bash
git rev-list --objects --all | grep -iE '\.(bank|zip|soundize)$'
```