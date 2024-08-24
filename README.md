# Linux bootstrapping tools for @ajhalili2006

A companion to [dotfiles](https://mau.dev/andreijiroh-dev/dotfiles) on setting up a
fresh Linux install, containing a combination of shell scripts and Ansible playbooks.

## Usage

> [!warning]
> Most Ansible playbooks with `*-setup.yml` in filename are intended for use in

This repository should be accessed as a local copy in a portable storage, perferrably
in a [Ventoy]-like setup. Once you mounted the partition where it is stored, run
the `scripts/bootstrap.sh` script by its absolute path.

```bash
/path/to/bootstrapper/scripts/bootstrap.sh
```

### Supported variables

* `ANSIBLE_VAR_USERNAME` - Used for user creation
* `ANSIBLE_VAR_HOSTNAME` - Used when changing default hostname

## Testing

### Via Docker

In Arch:

```bash
docker run --pull=always --rm -it -e DEBUG=true -v $PWD:/bootstrap archlinux /bootstrap/scripts/bootstrap.sh
```