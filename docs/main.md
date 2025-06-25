## Funkcje

- Tworzenie maszyn wirtualnych na podstawie istniejącego szablonu
- Konfiguracja CPU, pamięci, sieci i użytkownika technicznego
- Obsługa ochrony VM oraz przypisania do puli zasobów
- Automatyczne generowanie hasła technicznego użytkownika (jeśli nie podano)
- Konfiguracja VLAN w zależności od środowiska (DMZ lub nie)

---
## Przykład użycia

```hcl
module "vm01002" {
  source = "git@gitlab.com:pl.rachuna-net/infrastructure/terraform/modules/proxmox-vm.git?ref=v1.1.0"

  hostname      = "vm01002"
  description   = "gitlab-runner s2"
  node_name     = "pve-s2"
  tags          = ["gitlab-runner", "alpine-3"]
  pool_id       = "gitlab-runner"
  vm_id         = 1002
  is_dmz        = false
  protection    = true

  template {
    node_name = "pve-s2"  
    vm_id     = 100
  }
  memory {
    dedicated = 2048
    floating  = 2048
  }

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  technical_user {
    username     = "admin"
    password     = null # random generated
    ssh_pub_key  = var.technical_user_ssh_pub_key
  }
}
```

---
## Wejścia (Inputs)

| Nazwa           | Typ          | Opis                                                    | Domyślna wartość |
|-----------------|--------------|---------------------------------------------------------|------------------|
| hostname        | string       | Nazwa hosta maszyny wirtualnej                          | -                |
| description     | string       | Opis maszyny wirtualnej                                 | -                |
| node_name       | string       | Nazwa węzła Proxmox, na którym VM będzie działać        | -                |
| tags            | list(string) | Tag'i przypisane do VM                                  | -                |
| pool_id         | string       | Identyfikator puli zasobów                              | -                |
| vm_id           | number       | Identyfikator maszyny wirtualnej                        | -                |
| protection      | bool         | Włączenie ochrony VM                                    | false            |
| template        | object       | Szablon VM (node_name, vm_id, opcjonalnie full)         | -                |
| memory          | object       | Pamięć VM (dedicated, floating)                         | -                |
| cpu             | object       | CPU VM (cores, sockets, type)                           | -                |
| technical_user  | object       | Użytkownik techniczny (username, password, ssh_pub_key) | -                |
| is_dmz          | bool         | Czy środowisko produkcyjne (ustawia VLAN)               | false            |
| mac_address     | string       | Opcjonalny adres MAC dla VM                             | null             |

---
## Wyjścia (Outputs)

| Nazwa | Opis                  |
|-------|-----------------------|
| id    | Identyfikator VM (vm_id) |

---
## Uwagi

- Jeśli nie zostanie podane hasło dla użytkownika technicznego, zostanie ono wygenerowane losowo.
- VLAN jest ustawiany na 20, jeśli `is_dmz` jest `true`, w przeciwnym razie na 10.
- Maszyna wirtualna jest tworzona na podstawie klonowania szablonu wskazanego w bloku `template`.

