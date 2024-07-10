Require Export ZArith.
Require Import Lia.
From Equations Require Import Equations.
From AAC_tactics Require Import AAC Instances.
Import P.
Import Peano.

Open Scope positive_scope.

Record logtype : Set := log {
    log_of : positive
  }.

Definition add_log (a: logtype) (b: logtype) := log (log_of a * log_of b).

Declare Scope log_scope.

Bind Scope log_scope with logtype.

Notation "a + b" := (add_log a b) : log_scope.

Equations as_log (x: nat) : logtype :=
| O => log 1
| S x => log 2 + as_log x.

Definition lt_log (a: logtype) (b: logtype) := log_of a < log_of b.

Notation "a < b" := (lt_log a b) : log_scope.

Definition le_log (a: logtype) (b: logtype) := log_of a <= log_of b.

Notation "a <= b" := (le_log a b) : log_scope.

Definition gt_log (a: logtype) (b: logtype) := log_of a > log_of b.

Notation "a > b" := (gt_log a b) : log_scope.

Definition ge_log (a: logtype) (b: logtype) := log_of a >= log_of b.

Notation "a >= b" := (ge_log a b) : log_scope.

Definition max_log (a: logtype) (b: logtype) := log (Pos.max (log_of a) (log_of b)).

Definition min_log (a: logtype) (b: logtype) := log (Pos.min (log_of a) (log_of b)).

Definition floor (a: logtype) := Nat.pred (Pos.size_nat (log_of a)).

Open Scope log_scope.

Lemma eq_log_equiv : forall a b, a = b <-> log_of a = log_of b.
Proof.
  intuition.
  - destruct a. destruct b. inversion H. subst. auto.
  - destruct a. destruct b. simpl in *. subst. auto.
Qed.

Lemma add_log_comm : forall a b, a + b = b + a.
Proof.
  intros. unfold add_log. rewrite eq_log_equiv. simpl. aac_reflexivity.
Qed.

Lemma add_log_assoc: forall a b c, a + (b + c) = a + b + c.
Proof.
  intros. unfold add_log. rewrite eq_log_equiv. simpl.
  aac_reflexivity.
Qed.

#[export] Instance aac_log_add_Assoc : Associative eq add_log := add_log_assoc.
#[export] Instance aac_log_add_Comm : Commutative eq add_log := add_log_comm.

Lemma max_log_comm : forall a b, max_log a b = max_log b a.
Proof.
  intros. unfold max_log. rewrite eq_log_equiv. simpl. aac_reflexivity.
Qed.

Lemma max_log_assoc : forall a b c, max_log a (max_log b c) = max_log (max_log a b) c.
Proof.
  intros. unfold max_log. rewrite eq_log_equiv. simpl. aac_reflexivity.
Qed.

Lemma max_log_idempotent : forall a, max_log a a = a.
Proof.
  intros. unfold max_log. rewrite eq_log_equiv. simpl. aac_reflexivity.
Qed.

#[export] Instance aac_log_max_Assoc : Associative eq max_log := max_log_assoc.
#[export] Instance aac_log_max_Comm : Commutative eq max_log := max_log_comm.
#[export] Instance aac_log_max_Idem : Idempotent eq max_log := max_log_idempotent.

Lemma min_log_comm : forall a b, min_log a b = min_log b a.
Proof.
  intros. unfold min_log. rewrite eq_log_equiv. simpl. aac_reflexivity.
Qed.

Lemma min_log_assoc : forall a b c, min_log a (min_log b c) = min_log (min_log a b) c.
Proof.
  intros. unfold min_log. rewrite eq_log_equiv. simpl. aac_reflexivity.
Qed.

Lemma min_log_idempotent : forall a, min_log a a = a.
Proof.
  intros. unfold min_log. rewrite eq_log_equiv. simpl. aac_reflexivity.
Qed.

#[export] Instance aac_log_min_Assoc : Associative eq min_log := min_log_assoc.
#[export] Instance aac_log_min_Comm : Commutative eq min_log := min_log_comm.
#[export] Instance aac_log_min_Idem : Idempotent eq min_log := min_log_idempotent.

Lemma max_log_l_iff : forall a b, max_log a b = a <-> b <= a.
Proof.
  unfold max_log, le_log.
  intros. rewrite eq_log_equiv. simpl. apply Pos.max_l_iff.
Qed.

Lemma max_log_r_iff : forall a b, max_log a b = b <-> a <= b.
Proof.
  unfold max_log, le_log.
  intros. rewrite eq_log_equiv. simpl. apply Pos.max_r_iff.
Qed.

Lemma min_log_l_iff : forall a b, min_log a b = a <-> a <= b.
Proof.
  unfold min_log, le_log.
  intros. rewrite eq_log_equiv. simpl. apply Pos.min_l_iff.
Qed.

Lemma min_log_r_iff : forall a b, min_log a b = b <-> b <= a.
Proof.
  unfold min_log, le_log.
  intros. rewrite eq_log_equiv. simpl. apply Pos.min_r_iff.
Qed.

Lemma max_log_l : forall a b, b <= a -> max_log a b = a.
Proof.
  intros. apply max_log_l_iff. auto.
Qed.

Lemma max_log_r : forall a b, a <= b -> max_log a b = b.
Proof.
  intros. apply max_log_r_iff. auto.
Qed.

Lemma min_log_l : forall a b, a <= b -> min_log a b = a.
Proof.
  intros. apply min_log_l_iff. auto.
Qed.

Lemma min_log_r : forall a b, b <= a -> min_log a b = b.
Proof.
  intros. apply min_log_r_iff. auto.
Qed.

Lemma max_log_lub_iff_le : forall a b c, max_log a b <= c <-> a <= c /\ b <= c.
Proof.
  intros. unfold max_log, le_log. simpl. apply Pos.max_lub_iff.
Qed.

Lemma max_log_lub_iff_lt : forall a b c, max_log a b < c <-> a < c /\ b < c.
Proof.
  intros. unfold max_log, lt_log. simpl. apply Pos.max_lub_lt_iff.
Qed.

Lemma min_log_glb_iff_le : forall a b c, c <= min_log a b <-> c <= a /\ c <= b.
Proof.
  intros. unfold min_log, le_log. simpl. apply Pos.min_glb_iff.
Qed.

Lemma min_log_glb_iff_lt : forall a b c, c < min_log a b <-> c < a /\ c < b.
Proof.
  intros. unfold min_log, lt_log. simpl. apply Pos.min_glb_lt_iff.
Qed.

Lemma add_max_log_distr_r : forall a b c, max_log (a + c) (b + c) = max_log a b + c.
Proof.
  intros. rewrite eq_log_equiv. unfold max_log, add_log. simpl.
  apply Pos.mul_max_distr_r.
Qed.

Lemma add_max_log_distr_l : forall a b c, max_log (c + a) (c + b) = c + max_log a b.
Proof. 
  intros. rewrite eq_log_equiv. unfold max_log, add_log. simpl.
  apply Pos.mul_max_distr_l.
Qed.

Lemma add_min_log_distr_r : forall a b c, min_log (a + c) (b + c) = min_log a b + c.
Proof.
  intros. rewrite eq_log_equiv. unfold min_log, add_log. simpl.
  apply Pos.mul_min_distr_r.
Qed.

Lemma add_min_log_distr_l : forall a b c, min_log (c + a) (c + b) = c + min_log a b.
Proof. 
  intros. rewrite eq_log_equiv. unfold min_log, add_log. simpl.
  apply Pos.mul_min_distr_l.
Qed.

Lemma log_of_add : forall a b, log_of (a + b) = log_of a * log_of b.
Proof.
  unfold add_log. simpl. auto.
Qed.

Lemma as_log_add : forall a b, as_log (a + b) = as_log a + as_log b.
Proof.
  intro. induction a.
  - intros. simp as_log. rewrite eq_log_equiv. simpl. auto.
  - intros. simpl. simp as_log. rewrite IHa. aac_reflexivity.
Qed.

Lemma add_lt_log_mono_l : forall a b c, b < c -> a + b < a + c.
Proof.
  unfold lt_log, add_log. intros. simpl. apply Pos.mul_lt_mono_l. auto.
Qed.

Lemma add_le_log_mono_l : forall a b c, b <= c -> a + b <= a + c.
Proof.
  unfold le_log, add_log. intros. simpl. apply Pos.mul_le_mono_l. auto.
Qed.

Lemma add_gt_log_mono_l : forall a b c, b > c -> a + b > a + c.
Proof.
  unfold gt_log, add_log. intros. simpl.
  rewrite Pos.gt_lt_iff in *. apply Pos.mul_lt_mono_l. auto.
Qed.

Lemma add_ge_log_mono_l : forall a b c, b >= c -> a + b >= a + c.
Proof.
  unfold ge_log, add_log. intros. simpl. rewrite Pos.ge_le_iff in *.
  apply Pos.mul_le_mono_l. auto.
Qed.

Lemma add_lt_log_mono_r : forall a b c, b < c -> b + a < c + a.
Proof.
  unfold lt_log, add_log. intros. simpl. apply Pos.mul_lt_mono_r. auto.
Qed.

Lemma add_le_log_mono_r : forall a b c, b <= c -> b + a <= c + a.
Proof.
  unfold le_log, add_log. intros. simpl. apply Pos.mul_le_mono_r. auto.
Qed.

Lemma add_gt_log_mono_r : forall a b c, b > c -> b + a > c + a.
Proof.
  unfold gt_log, add_log. intros. simpl.
  rewrite Pos.gt_lt_iff in *. apply Pos.mul_lt_mono_r. auto.
Qed.

Lemma add_ge_log_mono_r : forall a b c, b >= c -> b + a >= c + a.
Proof.
  unfold ge_log, add_log. intros. simpl. rewrite Pos.ge_le_iff in *.
  apply Pos.mul_le_mono_r. auto.
Qed.

Lemma as_log_lt : forall a b, (a < b)%nat -> as_log a < as_log b.
  intros. funelim (as_log a); funelim (as_log b); try easy.
  apply add_lt_log_mono_l. apply H0. rewrite Nat.succ_lt_mono. auto.
Qed.

Lemma as_log_le : forall a b, (a <= b)%nat -> as_log a <= as_log b.
  intros. funelim (as_log a); funelim (as_log b); try easy.
  apply add_le_log_mono_l. apply H0. rewrite Nat.succ_le_mono. auto.
Qed.

Lemma as_log_gt : forall a b, (a > b)%nat -> as_log a > as_log b.
  intros. funelim (as_log a); funelim (as_log b); try easy.
  apply add_gt_log_mono_l. apply H0. unfold gt in *. rewrite Nat.succ_lt_mono. auto.
Qed.

Lemma as_log_ge : forall a b, (a >= b)%nat -> as_log a >= as_log b.
  intros. funelim (as_log a); funelim (as_log b); try easy.
  apply add_ge_log_mono_l. apply H0. unfold ge in *. rewrite Nat.succ_le_mono. auto.
Qed.


Lemma as_log_max : forall a b, as_log (max a b) = max_log (as_log a) (as_log b).
Proof.
  intros. destruct (Nat.lt_trichotomy a b) as [H | [H | H]].
  - rewrite Nat.max_r; try lia. unfold max_log.
    apply as_log_lt in H. unfold lt_log in *. rewrite Pos.max_r; try lia.
    rewrite eq_log_equiv. auto.
  -  subst. aac_normalise. rewrite Nat.max_id. auto.
  - rewrite Nat.max_l; try lia. unfold max_log.
    apply as_log_lt in H. unfold lt_log in *. rewrite Pos.max_l; try lia.
    rewrite eq_log_equiv. auto.
Qed.

Equations mul_log (n: nat) (a: logtype) : logtype :=
| O, _ => log 1
| S n, a => mul_log n a + a.

Notation "n * a" := (mul_log n a) : log_scope.

Lemma mul_le_log_mono_l : forall n a b, a <= b -> n * a <= n * b.
Proof.
  intros. induction n; simp mul_log; unfold le_log; try lia.
  unfold add_log. simpl. apply Pos.mul_le_mono; auto.
Qed.

Lemma mul_le_log_mono_r : forall n m a, (n <= m)%nat -> n * a <= m * a.
Proof.
  intros. induction H; simp mul_log; unfold le_log; try lia.
  unfold add_log. simpl. replace (log_of (n * a)) with ((log_of (n * a)) * 1)%positive by lia.
  apply Pos.mul_le_mono; auto. lia.
Qed.

Lemma mul_add_log_distrib_r : forall n a b, n * (a + b) = n * a + n * b.
Proof.
  intros. induction n; simp mul_log; auto.
  rewrite IHn. aac_reflexivity.
Qed.

Lemma mul_add_log_distrib_l : forall n m a, (n + m) * a = n * a + m * a.
Proof.
  intros. induction n; unfold add_log; simpl; simp mul_log; simpl.
  - rewrite eq_log_equiv. auto.
  - rewrite IHn. unfold add_log. rewrite eq_log_equiv. simpl. aac_reflexivity.
Qed.

Lemma le_pos_dicho : forall a b, (a <= b \/ b <= a)%positive.
Proof.
  lia.
Qed.

Lemma le_log_dicho : forall a b, a <= b \/ b <= a.
Proof.
  intros. apply le_pos_dicho.
Qed.

Lemma mul_max_log_distrib_r : forall n a b, n * (max_log a b) = max_log (n * a) (n * b).
Proof.
  intros. induction n; simp mul_log; unfold max_log in *; simpl; auto. rewrite IHn.
  unfold add_log. simpl. apply eq_log_equiv. simpl.
  destruct (le_pos_dicho (log_of a) (log_of b)).
  - rewrite (Pos.max_r _ _ H). apply (mul_le_log_mono_l n) in H as H0. rewrite (Pos.max_r _ _ H0).
    rewrite Pos.max_r; auto. apply Pos.mul_le_mono; auto.
  - rewrite (Pos.max_l _ _ H). apply (mul_le_log_mono_l n) in H as H0. rewrite (Pos.max_l _ _ H0).
    rewrite Pos.max_l; auto. apply Pos.mul_le_mono; auto.
Qed.

Lemma log1_unit_add_l : forall a, log 1 + a = a.
Proof.
  intro. unfold add_log. rewrite eq_log_equiv. simpl. auto.
Qed.

Lemma log1_unit_add_r : forall a, a + log 1 = a.
Proof.
  intro. unfold add_log. rewrite eq_log_equiv. simpl. lia.
Qed.

#[export] Instance wf_pos_lt : WellFounded Pos.lt.
red. red. assert (forall n a, Pos.to_nat a - 1 < n -> Acc Pos.lt a)%nat.
- induction n; try lia. intros. constructor. intros. apply IHn. lia.
- intros. apply (H (S (Pos.to_nat a - 1))). auto.
Qed.

Lemma acc_pos_log : forall p, Acc Pos.lt p <-> Acc lt_log (log p).
Proof.
  intuition.
  - induction H. constructor. intro. destruct y. unfold lt_log. simpl. intro. apply H0. auto.
  - remember (log p). replace p with (log_of l).
    + clear dependent p. induction H. constructor. intros. remember (log y).
      replace y with (log_of l).
      * assert (l < x). { unfold lt_log. rewrite Heql. simpl. auto. }
        auto.
      * rewrite Heql; auto.
    + rewrite Heql; auto.
Qed.

#[export] Instance wf_lt_log : WellFounded lt_log.
intro. destruct a. rewrite <- acc_pos_log. apply wf_pos_lt.
Qed.

Close Scope log_scope.

Close Scope positive_scope.
