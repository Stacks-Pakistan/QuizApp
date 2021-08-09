;; Data Maps & Vars
(define-map correctAnswers-map { id: uint } { answer: (string-ascii 50) }  )
(define-data-var score uint u0)

;; Error Constants
(define-constant ERR_UNKNOWN_QUESTION u200)
(define-constant ERR_WRONG_ANSWER u201)

;; Check if Answer is correct. if it is corrrect then increase score
(define-public (check-answer (question-id uint) (user-answer (string-ascii 50)))
  (let
    (
     ;; if key/question-id not found then return error constant
     (correct-answer (get answer (unwrap! (map-get? correctAnswers-map { id: question-id }) (err ERR_UNKNOWN_QUESTION))))
     (newScore (+ (var-get score) u1))
    )

    ;; if not equal then return error constant else update score with new score and return it.
    (asserts! (is-eq correct-answer user-answer) (err ERR_WRONG_ANSWER))
    (var-set score newScore)
    (ok newScore)
  )
)

;; Returns true if successfully inserted else false
(define-public (add-question (question-id uint) (correct-answer (string-ascii 50)))
     (ok (map-insert correctAnswers-map { id: question-id } { answer: correct-answer }))
)

;; Returns true if successfully deleted else false
(define-public (delete-question (question-id uint))
     (ok (map-delete correctAnswers-map { id: question-id }))
)


;; Returns true if successfully changed, else error if key not found
(define-public (change-answer (question-id uint) (new-answer (string-ascii 50)))
  (let
    (
     (is-exists (get answer (unwrap! (map-get? correctAnswers-map { id: question-id }) (err ERR_UNKNOWN_QUESTION))))
    )

    (ok (map-set correctAnswers-map { id: question-id } { answer: new-answer }))
  )
)

;; Read-only function to return current score
(define-read-only (get-score)
  (ok (var-get score))
)

    