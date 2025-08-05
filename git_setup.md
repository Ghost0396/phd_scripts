# GitHub setup

Set up git
```python
git config --global user.name "username"
git config --global user.email "email@mail.com"
```

1. Create a key

```python
ssh-keygen -t ed25519 -C "email@mail.com"
```

2. Add key
```python
ssh-add ~/.ssh/id_nnn
```

3. Copy key to GutHub

```python
cat ~/.ssh/id_nnn.pub
```

4. Change to ssh

```python
git remote set-url origin git@github.com:user/repository.git
```

5. Push it

```python
git push origin main
```

